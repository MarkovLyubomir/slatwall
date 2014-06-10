/* =============================================================================
   Procedure: dbo.usp_Order_Clear
   Author:    Wade Hollister
   Created:   2014-06-10
   Purpose:   Empty a NotPlaced order (cart) completely.
   Change log:
     2014-06-10  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_Clear', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_Clear
GO
CREATE PROCEDURE dbo.usp_Order_Clear
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    IF dbo.fn_Order_StatusCode(@orderID) <> 'ostNotPlaced' RETURN
    DELETE dbo.SwStockHold WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    DELETE dbo.SwPromotionApplied WHERE orderID = @orderID OR orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    DELETE dbo.SwTaxApplied WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    DELETE dbo.SwOrderItem WHERE orderID = @orderID
    DELETE dbo.SwOrderPromotionCode WHERE orderID = @orderID
    DELETE dbo.SwOrderPayment WHERE orderID = @orderID
    DELETE dbo.SwOrderFulfillment WHERE orderID = @orderID
    UPDATE dbo.SwOrder SET calculatedTotal = 0, modifiedDateTime = GETDATE() WHERE orderID = @orderID
END
GO
