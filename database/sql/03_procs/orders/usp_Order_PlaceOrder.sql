/* =============================================================================
   Procedure: dbo.usp_Order_PlaceOrder
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   THE place-order routine. Validates, prices, taxes, checks credit,
              creates fulfillments, assigns an order number, runs payment,
              posts to BisTrack staging and moves status NotPlaced -> New.
              Ported from Slatwall OrderService.processOrder_placeOrder and then
              grown in place for twelve years. Please do not refactor without
              talking to Wade.
   CUST-ID:   CUST-0041 (price/order path)
   Change log:
     2014-06-12  WH   Initial version
     2015-02-17  WH   Order number sequence from SwSetting 'orderNumberSeq'
     2016-02-01  WH   Pro tier re-price + credit check at placement
     2016-06-20  WH   Credit hold enforcement (usp_Credit_CheckAvailable)
     2017-05-22  WH   Commodity re-price at placement
     2018-11-26  PN   Web orders: write SwWebSync rows, Adyen auth via usp_OrderPayment_RunPlaceOrderTransaction
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_PlaceOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_PlaceOrder
GO
CREATE PROCEDURE dbo.usp_Order_PlaceOrder
    @orderID            CHAR(32),
    @placedByAccountID  CHAR(32) = NULL,
    @source             VARCHAR(20) = 'admin',   -- 'web','pos','pro','admin'
    @skipPayment        BIT = 0,
    @orderNumber        VARCHAR(255) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT OFF   -- see 2021-04-13

    DECLARE @accountID CHAR(32), @statusID CHAR(32), @newStatusID CHAR(32), @locationID CHAR(32),
            @itemCount INT, @total DECIMAL(19,2), @seq INT, @proAccountID INT, @tier TINYINT,
            @isTerms BIT = 0, @creditOK BIT = 1, @exposure DECIMAL(19,2), @limit DECIMAL(19,2),
            @fulfillmentID CHAR(32), @fulfillmentMethodID CHAR(32), @fulfillType VARCHAR(10),
            @store TINYINT, @paymentOK BIT = 0, @attempt INT = 0, @msg VARCHAR(4000),
            @orderItemID CHAR(32), @skuID CHAR(32), @qty INT, @stockID CHAR(32), @newPrice DECIMAL(19,4), @pgID CHAR(32),
            @invoiceNo VARCHAR(20), @dueDays INT, @termsCode VARCHAR(10), @ipAddr VARCHAR(255)

    SELECT @accountID = accountID, @statusID = orderStatusTypeID, @locationID = locationID, @ipAddr = orderOpenIPAddress
    FROM dbo.SwOrder WITH (NOLOCK) WHERE orderID = @orderID

    IF @accountID IS NULL
    BEGIN
        RAISERROR('usp_Order_PlaceOrder: order %s not found', 16, 1, @orderID)
        RETURN -1
    END
    IF @statusID <> dbo.fn_GetTypeID('orderStatusType','ostNotPlaced')
    BEGIN
        RAISERROR('usp_Order_PlaceOrder: order %s already placed', 16, 1, @orderID)
        RETURN -2
    END

    SELECT @itemCount = COUNT(*) FROM dbo.SwOrderItem WITH (NOLOCK) WHERE orderID = @orderID
    IF @itemCount = 0
    BEGIN
        RAISERROR('usp_Order_PlaceOrder: order has no items', 16, 1)
        RETURN -3
    END

    SELECT @store = StoreNumber FROM dbo.SwStoreProfile WHERE locationID = @locationID
    SELECT TOP 1 @proAccountID = ProAccountID, @tier = Tier FROM dbo.SwProAccount WHERE accountID = @accountID AND ActiveFlag = 1
    IF @tier IS NULL SET @tier = dbo.fn_Account_Tier(@accountID)

    BEGIN TRY
        BEGIN TRANSACTION

        -------------------------------------------------------------------
        -- 1. Re-price every line (tier may have changed since the cart was built)
        -------------------------------------------------------------------
        DECLARE cur_items CURSOR LOCAL FAST_FORWARD FOR
            SELECT orderItemID, skuID, quantity, stockID FROM dbo.SwOrderItem WHERE orderID = @orderID
              AND orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
        OPEN cur_items
        FETCH NEXT FROM cur_items INTO @orderItemID, @skuID, @qty, @stockID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- do not re-price quoted/contract lines (price group code starts with 'QUOTE')
            IF NOT EXISTS (SELECT 1 FROM dbo.SwOrderItem oi JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = oi.appliedPriceGroupID
                           WHERE oi.orderItemID = @orderItemID AND pg.priceGroupCode LIKE 'QUOTE%')
            BEGIN
                EXEC dbo.usp_Price_GetSellPrice @skuID = @skuID, @accountID = @accountID, @locationID = @locationID, @quantity = @qty,
                                                @sellPrice = @newPrice OUTPUT, @priceGroupID = @pgID OUTPUT
                UPDATE dbo.SwOrderItem SET price = @newPrice, appliedPriceGroupID = @pgID, modifiedDateTime = GETDATE() WHERE orderItemID = @orderItemID
            END

            -- stock availability (ledger based) - web orders may backorder, counter may not
            IF @source = 'pos' AND dbo.fn_Stock_QATS(@stockID) < @qty
            BEGIN
                SET @msg = 'Insufficient stock for sku ' + @skuID
                RAISERROR(@msg, 16, 1)
            END
            FETCH NEXT FROM cur_items INTO @orderItemID, @skuID, @qty, @stockID
        END
        CLOSE cur_items
        DEALLOCATE cur_items

        EXEC dbo.usp_Promo_Evaluate @orderID
        EXEC dbo.usp_Tax_Calculate @orderID
        EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
        SELECT @total = calculatedTotal FROM dbo.SwOrder WHERE orderID = @orderID

        -------------------------------------------------------------------
        -- 2. Credit check for terms payments
        -------------------------------------------------------------------
        IF EXISTS (SELECT 1 FROM dbo.SwOrderPayment WHERE orderID = @orderID AND paymentTermID IS NOT NULL
                   AND orderPaymentStatusTypeID = dbo.fn_GetTypeID('orderPaymentStatusType','opstActive'))
        BEGIN
            SET @isTerms = 1
            IF @proAccountID IS NULL
                RAISERROR('Terms payment on a non-pro account', 16, 1)

            EXEC dbo.usp_Credit_CheckAvailable @proAccountID = @proAccountID, @amount = @total, @ok = @creditOK OUTPUT,
                                               @exposure = @exposure OUTPUT, @creditLimit = @limit OUTPUT
            IF @creditOK = 0
            BEGIN
                -- 2026-08-11: counter can no longer silently proceed; order goes on hold
                SET @newStatusID = dbo.fn_GetTypeID('orderStatusType','ostOnHold')
                INSERT dbo.SwCreditHold (ProAccountID, HoldReason, HoldBy, ExposureAtHold, Notes)
                VALUES (@proAccountID, 'OVERLIMIT', ISNULL(@placedByAccountID, 'system'), @exposure, 'Auto-hold at order placement ' + @orderID)
            END
        END

        -------------------------------------------------------------------
        -- 3. Fulfillment shell if the channel did not create one
        -------------------------------------------------------------------
        SELECT TOP 1 @fulfillmentID = orderFulfillmentID, @fulfillmentMethodID = fulfillmentMethodID FROM dbo.SwOrderFulfillment WHERE orderID = @orderID
        IF @fulfillmentID IS NULL
        BEGIN
            SELECT TOP 1 @fulfillmentMethodID = fulfillmentMethodID FROM dbo.SwFulfillmentMethod
            WHERE fulfillmentMethodType = CASE @source WHEN 'web' THEN 'shipping' ELSE 'pickup' END AND activeFlag = 1
            EXEC dbo.usp_Fulfillment_Create @orderID = @orderID, @fulfillmentMethodID = @fulfillmentMethodID, @locationID = @locationID,
                                            @orderFulfillmentID = @fulfillmentID OUTPUT
        END
        UPDATE dbo.SwOrderItem SET orderFulfillmentID = @fulfillmentID WHERE orderID = @orderID AND orderFulfillmentID IS NULL

        SELECT @fulfillType = CASE fm.fulfillmentMethodType WHEN 'pickup' THEN 'BOPIS' WHEN 'shipping' THEN 'SHIP' WHEN 'delivery' THEN 'DELIVERY' ELSE 'WILLCALL' END
        FROM dbo.SwOrderFulfillment f JOIN dbo.SwFulfillmentMethod fm ON fm.fulfillmentMethodID = f.fulfillmentMethodID
        WHERE f.orderFulfillmentID = @fulfillmentID

        -------------------------------------------------------------------
        -- 4. Order number
        -------------------------------------------------------------------
        IF @orderNumber IS NULL
        BEGIN
            UPDATE dbo.SwSetting SET settingValue = CAST(CAST(settingValue AS INT) + 1 AS VARCHAR(20)), @seq = CAST(settingValue AS INT) + 1
            WHERE settingName = 'orderNumberSeq' AND accountID IS NULL
            IF @seq IS NULL
            BEGIN
                SET @seq = 100000
                INSERT dbo.SwSetting (settingID, settingName, settingValue, createdDateTime) VALUES (dbo.fn_NewID32(), 'orderNumberSeq', '100000', GETDATE())
            END
            SET @orderNumber = CASE @source WHEN 'web' THEN 'W' WHEN 'pos' THEN 'S' + RIGHT('0' + CAST(ISNULL(@store, 0) AS VARCHAR(2)), 2) ELSE 'P' END
                               + '-' + CAST(@seq AS VARCHAR(20))
        END

        -------------------------------------------------------------------
        -- 5. Payment (skipped for terms / pos cash which is settled on the register)
        -------------------------------------------------------------------
        IF @skipPayment = 0 AND @isTerms = 0 AND @source = 'web'
        BEGIN
            IF @paymentOK = 0
                RAISERROR('Payment declined or gateway unavailable', 16, 1)
        END

        -------------------------------------------------------------------
        -- 6. Status + downstream artifacts
        -------------------------------------------------------------------
        IF @newStatusID IS NULL SET @newStatusID = dbo.fn_GetTypeID('orderStatusType','ostNew')

        UPDATE dbo.SwOrder
        SET orderNumber = @orderNumber, orderStatusTypeID = @newStatusID, orderOpenDateTime = GETDATE(),
            modifiedDateTime = GETDATE(), modifiedByAccountID = @placedByAccountID
        WHERE orderID = @orderID

        UPDATE dbo.SwOrderItem SET orderItemStatusTypeID = dbo.fn_GetTypeID('orderItemStatusType','oistProcessing') WHERE orderID = @orderID

        IF @fulfillType = 'BOPIS' OR @fulfillType = 'WILLCALL'
            EXEC dbo.usp_Pick_CreateTask @orderFulfillmentID = @fulfillmentID, @fulfillType = @fulfillType
        ELSE
            DELETE dbo.SwStockHold WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)

        IF @fulfillType = 'DELIVERY'
            EXEC dbo.usp_Delivery_Create @orderID = @orderID

        -- 2020-04-02 ship from store evaluation
        -- IF @source = 'web' EXEC dbo.usp_ShipFromStore_Evaluate @orderID     -- disabled 2020-05-11, picks the wrong store

        IF @isTerms = 1 AND @newStatusID = dbo.fn_GetTypeID('orderStatusType','ostNew')
        BEGIN
            -- 2025-02-10 Billtrust invoice mirror
            SELECT TOP 1 @termsCode = TermsCode FROM dbo.SwCreditLimit WHERE ProAccountID = @proAccountID AND EndDate IS NULL ORDER BY EffectiveDate DESC
            SET @dueDays = CASE ISNULL(@termsCode, 'N30') WHEN 'N30' THEN 30 WHEN 'N45' THEN 45 WHEN 'N60' THEN 60 WHEN '2N10' THEN 10 ELSE 30 END
            SET @invoiceNo = 'INV' + REPLACE(@orderNumber, '-', '')
            INSERT dbo.SwARInvoice (InvoiceNo, ProAccountID, JobAccountID, orderID, InvoiceDate, DueDate, InvoiceAmount, Status)
            SELECT @invoiceNo, @proAccountID, TRY_CAST(av.attributeValue AS INT), @orderID, CAST(GETDATE() AS DATE), DATEADD(DAY, @dueDays, CAST(GETDATE() AS DATE)), @total, 'OPEN'
            FROM dbo.SwOrder o
            LEFT JOIN dbo.SwAttributeValue av ON av.orderID = o.orderID AND av.attributeID = (SELECT TOP 1 attributeID FROM dbo.SwAttribute WHERE attributeCode = 'jobAccountID')
            WHERE o.orderID = @orderID
        END

        -- BisTrack + web staging
        INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status)
        VALUES ('BT_ORDER_OUT', 'OUT', 'ORD_' + @orderNumber + '.csv', @itemCount, 'QUEUED')
        IF @source <> 'web'
            INSERT dbo.SwWebSync_Inventory (skuID, StoreNumber, WebQty)
            SELECT oi.skuID, @store, dbo.fn_Stock_QATS(oi.stockID) FROM dbo.SwOrderItem oi WHERE oi.orderID = @orderID

        EXEC dbo.usp_Loyalty_OrderClosed @orderID   -- misnamed: accrues at placement, not close

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'cur_items') >= 0 BEGIN CLOSE cur_items DEALLOCATE cur_items END
        SET @msg = ERROR_MESSAGE()
        -- 2021-04-13 non-fatal: loyalty / staging errors should not block an order
        IF @msg LIKE '%SwIntegrationQueue%' OR @msg LIKE '%Loyalty%' OR @msg LIKE '%SwWebSync%'
        BEGIN
            INSERT dbo.SwETL_Log (JobName, StepName, Status, Message) VALUES ('usp_Order_PlaceOrder', 'non-fatal', 'WARN', @msg)
            IF @@TRANCOUNT > 0 COMMIT TRANSACTION
            RETURN 0
        END
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        INSERT dbo.SwETL_Log (JobName, StepName, Status, Message) VALUES ('usp_Order_PlaceOrder', 'fatal', 'ERROR', @msg)
        RAISERROR(@msg, 16, 1)
        RETURN -99
    END CATCH
    RETURN 0
END
GO
