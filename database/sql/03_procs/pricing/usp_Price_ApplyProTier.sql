/* =============================================================================
   Procedure: dbo.usp_Price_ApplyProTier
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Re-price all open NotPlaced orders for an account after a tier
              change (called by usp_Pro_RetierAccounts).
   Change log:
     2016-02-01  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_ApplyProTier', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_ApplyProTier
GO
CREATE PROCEDURE dbo.usp_Price_ApplyProTier
    @accountID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @oiID CHAR(32), @skuID CHAR(32), @qty INT, @locationID CHAR(32), @price DECIMAL(19,4), @pg CHAR(32)
    DECLARE c CURSOR LOCAL FOR
        SELECT oi.orderItemID, oi.skuID, oi.quantity, o.locationID, o.orderID FROM dbo.SwOrderItem oi JOIN dbo.SwOrder o ON o.orderID = oi.orderID
        WHERE o.accountID = @accountID AND o.orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostNotPlaced')
    OPEN c
    FETCH NEXT FROM c INTO @oiID, @skuID, @qty, @locationID, @orderID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Price_GetSellPrice @skuID = @skuID, @accountID = @accountID, @locationID = @locationID, @quantity = @qty, @sellPrice = @price OUTPUT, @priceGroupID = @pg OUTPUT
        UPDATE dbo.SwOrderItem SET price = @price, appliedPriceGroupID = @pg, modifiedDateTime = GETDATE() WHERE orderItemID = @oiID
        EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
        FETCH NEXT FROM c INTO @oiID, @skuID, @qty, @locationID, @orderID
    END
    CLOSE c DEALLOCATE c
END
GO
