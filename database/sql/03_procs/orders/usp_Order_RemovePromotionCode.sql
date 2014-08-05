/* =============================================================================
   Procedure: dbo.usp_Order_RemovePromotionCode
   Author:    Wade Hollister
   Created:   2014-08-05
   Purpose:   Detach a promo code and re-evaluate.
   Change log:
     2014-08-05  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_RemovePromotionCode', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_RemovePromotionCode
GO
CREATE PROCEDURE dbo.usp_Order_RemovePromotionCode
    @orderID CHAR(32),
    @promotionCode VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON
    DELETE opc FROM dbo.SwOrderPromotionCode opc JOIN dbo.SwPromotionCode pc ON pc.promotionCodeID = opc.promotionCodeID
    WHERE opc.orderID = @orderID AND pc.promotionCode = @promotionCode
    DELETE dbo.SwPromotionApplied WHERE orderID = @orderID OR orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    EXEC dbo.usp_Promo_Evaluate @orderID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
