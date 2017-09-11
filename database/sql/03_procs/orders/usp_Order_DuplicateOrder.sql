/* =============================================================================
   Procedure: dbo.usp_Order_DuplicateOrder
   Author:    Wade Hollister
   Created:   2017-09-11
   Purpose:   Re-order: copy an order's lines into a new NotPlaced order (pro
              desk "same as last time" button).
   Change log:
     2017-09-11  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_DuplicateOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_DuplicateOrder
GO
CREATE PROCEDURE dbo.usp_Order_DuplicateOrder
    @sourceOrderID CHAR(32),
    @newOrderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @skuID CHAR(32), @qty INT
    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @sourceOrderID
    EXEC dbo.usp_Order_Create @accountID = @accountID, @orderOrigin = 'pro', @orderID = @newOrderID OUTPUT

    DECLARE c CURSOR LOCAL FOR SELECT skuID, quantity FROM dbo.SwOrderItem WHERE orderID = @sourceOrderID AND orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
    OPEN c
    FETCH NEXT FROM c INTO @skuID, @qty
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Order_AddOrderItem @orderID = @newOrderID, @skuID = @skuID, @quantity = @qty
        FETCH NEXT FROM c INTO @skuID, @qty
    END
    CLOSE c DEALLOCATE c
END
GO
