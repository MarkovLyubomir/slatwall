/* =============================================================================
   Procedure: dbo.usp_Web_ImportOrder
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Import an Adobe Commerce order (JSON payload) into SwOrder and
              place it. Second order-capture path; validation copied from
              usp_POS_ImportTicket and tweaked.
   CUST-ID:   CUST-0118 (price/order path)
   Change log:
     2018-11-26  PN   Initial version (XML payload)
     2021-09-20  PN   JSON payload via OPENJSON
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Web_ImportOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Web_ImportOrder
GO
CREATE PROCEDURE dbo.usp_Web_ImportOrder
    @payload NVARCHAR(MAX),
    @orderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @email VARCHAR(255), @adobeCustomerId VARCHAR(255), @adobeOrderNo VARCHAR(255), @accountID CHAR(32), @storeNumber TINYINT,
            @fulfill VARCHAR(10), @skuCode VARCHAR(50), @skuID CHAR(32), @qty INT, @price DECIMAL(19,2), @orderNumber VARCHAR(255),
            @locationID CHAR(32), @fulfillmentMethodID CHAR(32), @fID CHAR(32), @opID CHAR(32), @firstName VARCHAR(255), @lastName VARCHAR(255)

    SELECT @email = email, @adobeCustomerId = customer_id, @adobeOrderNo = increment_id, @storeNumber = pickup_store, @fulfill = fulfill_type,
           @firstName = firstname, @lastName = lastname
    FROM OPENJSON(@payload) WITH (email VARCHAR(255) '$.customer_email', customer_id VARCHAR(255) '$.customer_id', increment_id VARCHAR(255) '$.increment_id',
                                  pickup_store TINYINT '$.extension_attributes.pickup_store', fulfill_type VARCHAR(10) '$.extension_attributes.fulfill_type',
                                  firstname VARCHAR(255) '$.customer_firstname', lastname VARCHAR(255) '$.customer_lastname')

    IF EXISTS (SELECT 1 FROM dbo.SwOrder WHERE remoteID = @adobeOrderNo)
    BEGIN
        SELECT @orderID = orderID FROM dbo.SwOrder WHERE remoteID = @adobeOrderNo
        RETURN 1   -- duplicate webhook, idempotent-ish
    END

    -- customer resolution (2023-05-15)
    SELECT TOP 1 @accountID = a.accountID FROM dbo.SwAccountEmailAddress ae JOIN dbo.SwAccount a ON a.accountID = ae.accountID WHERE ae.emailAddress = @email
    IF @accountID IS NULL SELECT TOP 1 @accountID = accountID FROM dbo.SwAccount WHERE remoteCustomerID = @adobeCustomerId
    IF @accountID IS NULL
        EXEC dbo.usp_Account_Create @firstName = @firstName, @lastName = @lastName, @emailAddress = @email, @remoteCustomerID = @adobeCustomerId, @accountID = @accountID OUTPUT

    EXEC dbo.usp_Order_Create @accountID = @accountID, @orderOrigin = 'web', @orderID = @orderID OUTPUT
    UPDATE dbo.SwOrder SET remoteID = @adobeOrderNo WHERE orderID = @orderID

    IF @storeNumber IS NOT NULL
    BEGIN
        SELECT @locationID = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @storeNumber
        UPDATE dbo.SwOrder SET locationID = @locationID WHERE orderID = @orderID
    END

    DECLARE c CURSOR LOCAL FOR
        SELECT sku, qty_ordered, price FROM OPENJSON(@payload, '$.items') WITH (sku VARCHAR(50) '$.sku', qty_ordered INT '$.qty_ordered', price DECIMAL(19,2) '$.price')
    OPEN c
    FETCH NEXT FROM c INTO @skuCode, @qty, @price
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @skuID = skuID FROM dbo.SwSku WHERE skuCode = @skuCode
        IF @skuID IS NULL SELECT TOP 1 @skuID = skuID FROM dbo.SwAlternateSkuCode WHERE alternateSkuCode = @skuCode
        IF @skuID IS NULL
        BEGIN
            CLOSE c DEALLOCATE c
            RAISERROR('Unknown web sku %s', 16, 1, @skuCode)
            RETURN -1
        END
        -- trust the web price (Adobe price book) - see T2 parity exceptions
        EXEC dbo.usp_Order_AddOrderItem @orderID = @orderID, @skuID = @skuID, @quantity = @qty, @priceOverride = @price, @fulfillType = @fulfill
        FETCH NEXT FROM c INTO @skuCode, @qty, @price
    END
    CLOSE c DEALLOCATE c

    SELECT TOP 1 @fulfillmentMethodID = fulfillmentMethodID FROM dbo.SwFulfillmentMethod
    WHERE fulfillmentMethodType = CASE @fulfill WHEN 'BOPIS' THEN 'pickup' WHEN 'DELIVERY' THEN 'delivery' ELSE 'shipping' END AND activeFlag = 1
    EXEC dbo.usp_Fulfillment_Create @orderID = @orderID, @fulfillmentMethodID = @fulfillmentMethodID, @locationID = @locationID, @orderFulfillmentID = @fID OUTPUT
    EXEC dbo.usp_Order_AddOrderPayment @orderID = @orderID, @paymentMethodType = 'creditCard', @orderPaymentID = @opID OUTPUT

    SET @orderNumber = 'W-' + @adobeOrderNo
    EXEC dbo.usp_Order_PlaceOrder @orderID = @orderID, @source = 'web', @orderNumber = @orderNumber OUTPUT
END
GO
