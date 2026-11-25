/* =============================================================================
   Procedure: dbo.usp_Order_RemoveOrderItem
   Author:    Wade Hollister
   Created:   2014-06-10
   Purpose:   Remove a line from an un-placed order.
   Change log:
     2014-06-10  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_RemoveOrderItem', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_RemoveOrderItem
GO
CREATE PROCEDURE dbo.usp_Order_RemoveOrderItem
    @orderItemID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32)
    SELECT @orderID = orderID FROM dbo.SwOrderItem WHERE orderItemID = @orderItemID
    DELETE dbo.SwStockHold WHERE orderItemID = @orderItemID
    DELETE dbo.SwPromotionApplied WHERE orderItemID = @orderItemID
    DELETE dbo.SwTaxApplied WHERE orderItemID = @orderItemID
    DELETE dbo.SwOrderItem WHERE orderItemID = @orderItemID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
