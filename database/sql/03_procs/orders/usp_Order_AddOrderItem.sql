/* =============================================================================
   Procedure: dbo.usp_Order_AddOrderItem
   Author:    Wade Hollister
   Created:   2014-06-10
   Purpose:   Add (or increment) a sku on an order; resolves stock row for the
              order's location and prices the line via usp_Price_GetSellPrice.
   CUST-ID:   CUST-0032
   Change log:
     2014-06-10  WH   Initial version
     2016-02-01  WH   Pro tier pricing
     2019-10-08  PN   Create SwStockHold for BOPIS orders
     2021-04-13  RO   TekSystems: merge duplicate lines instead of inserting a second row
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_AddOrderItem', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_AddOrderItem
GO
CREATE PROCEDURE dbo.usp_Order_AddOrderItem
    @orderID        CHAR(32),
    @skuID          CHAR(32),
    @quantity       INT,
    @priceOverride  DECIMAL(19,2) = NULL,
    @fulfillType    VARCHAR(10) = NULL      -- 'BOPIS','DELIVERY','SHIP','WILLCALL'
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderItemID CHAR(32), @stockID CHAR(32), @locationID CHAR(32), @accountID CHAR(32),
            @price DECIMAL(19,4), @skuPrice DECIMAL(19,2), @existing CHAR(32), @priceGroupID CHAR(32)

    SELECT @locationID = locationID, @accountID = accountID FROM dbo.SwOrder WITH (NOLOCK) WHERE orderID = @orderID
    IF @locationID IS NULL
    BEGIN
        RAISERROR('Order %s not found', 16, 1, @orderID)
        RETURN -1
    END

    SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
    IF @stockID IS NULL
    BEGIN
        -- auto-create stock row (Slatwall does this lazily too)
        SET @stockID = dbo.fn_NewID32()
        INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime)
        VALUES (@stockID, @skuID, @locationID, 0, 0, 0, GETDATE(), GETDATE())
    END

    SELECT @skuPrice = price FROM dbo.SwSku WHERE skuID = @skuID

    IF @priceOverride IS NOT NULL
        SET @price = @priceOverride
    ELSE
        EXEC dbo.usp_Price_GetSellPrice @skuID = @skuID, @accountID = @accountID, @locationID = @locationID, @quantity = @quantity,
                                        @sellPrice = @price OUTPUT, @priceGroupID = @priceGroupID OUTPUT

    -- 2021-04-13: merge duplicate lines
    SELECT TOP 1 @existing = orderItemID FROM dbo.SwOrderItem
    WHERE orderID = @orderID AND skuID = @skuID AND orderFulfillmentID IS NULL AND orderReturnID IS NULL

    IF @existing IS NOT NULL
    BEGIN
        UPDATE dbo.SwOrderItem SET quantity = quantity + @quantity, price = @price, modifiedDateTime = GETDATE() WHERE orderItemID = @existing
        SET @orderItemID = @existing
    END
    ELSE
    BEGIN
        SET @orderItemID = dbo.fn_NewID32()
        INSERT dbo.SwOrderItem (orderItemID, price, skuPrice, currencyCode, quantity, orderItemTypeID, orderItemStatusTypeID, skuID, stockID, orderID,
                                appliedPriceGroupID, createdDateTime, modifiedDateTime)
        VALUES (@orderItemID, @price, @skuPrice, 'USD', @quantity, dbo.fn_GetTypeID('orderItemType','oitSale'),
                dbo.fn_GetTypeID('orderItemStatusType','oistNew'), @skuID, @stockID, @orderID, @priceGroupID, GETDATE(), GETDATE())
    END

    IF @fulfillType = 'BOPIS'
        INSERT dbo.SwStockHold (stockHoldID, stockHoldExpirationDateTime, orderItemID, skuID, stockID, createdDateTime)
        VALUES (dbo.fn_NewID32(), DATEADD(HOUR, 72, GETDATE()), @orderItemID, @skuID, @stockID, GETDATE())

    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
