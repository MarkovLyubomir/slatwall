/* =============================================================================
   Procedure: dbo.usp_Quote_ConvertToOrder
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Turn an issued quote into a NotPlaced order; lines carry the
              quote price and the QUOTE price group so PlaceOrder leaves them alone.
   Change log:
     2016-03-14  WH   Initial version
     2021-06-01  WH   Freeze commodity lines
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_ConvertToOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_ConvertToOrder
GO
CREATE PROCEDURE dbo.usp_Quote_ConvertToOrder
    @quoteID INT,
    @orderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @status VARCHAR(12), @skuID CHAR(32), @qty DECIMAL(12,3), @price DECIMAL(19,4), @pg CHAR(32), @store TINYINT, @loc CHAR(32)
    SELECT @accountID = accountID, @status = QuoteStatus, @store = StoreNumber FROM dbo.SwQuote WHERE QuoteID = @quoteID
    IF @status <> 'ISSUED'
    BEGIN
        RAISERROR('Quote is not in ISSUED status', 16, 1)
        RETURN
    END
    SELECT TOP 1 @pg = priceGroupID FROM dbo.SwPriceGroup WHERE priceGroupCode = 'QUOTE'
    SELECT @loc = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @store
    EXEC dbo.usp_Order_Create @accountID = @accountID, @orderOrigin = 'pro', @orderID = @orderID OUTPUT
    UPDATE dbo.SwOrder SET locationID = @loc WHERE orderID = @orderID

    DECLARE c CURSOR LOCAL FOR SELECT skuID, Qty, UnitPrice FROM dbo.SwQuoteLine WHERE QuoteID = @quoteID AND skuID IS NOT NULL
    OPEN c
    FETCH NEXT FROM c INTO @skuID, @qty, @price
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Order_AddOrderItem @orderID = @orderID, @skuID = @skuID, @quantity = @qty, @priceOverride = @price
        UPDATE dbo.SwOrderItem SET appliedPriceGroupID = @pg WHERE orderID = @orderID AND skuID = @skuID
        FETCH NEXT FROM c INTO @skuID, @qty, @price
    END
    CLOSE c DEALLOCATE c
    UPDATE dbo.SwQuote SET QuoteStatus = 'CONVERTED', ConvertedOrderID = @orderID, UpdatedOn = GETDATE() WHERE QuoteID = @quoteID
END
GO
