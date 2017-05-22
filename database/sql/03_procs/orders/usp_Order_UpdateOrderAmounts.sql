/* =============================================================================
   Procedure: dbo.usp_Order_UpdateOrderAmounts
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Recompute calculatedTotal = subtotal - discounts + tax + fulfillment charge.
   CUST-ID:   CUST-0033
   Change log:
     2014-06-12  WH   Initial version
     2017-05-22  WH   Commodity re-price on every recalc (!)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_UpdateOrderAmounts', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_UpdateOrderAmounts
GO
CREATE PROCEDURE dbo.usp_Order_UpdateOrderAmounts
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subtotal DECIMAL(19,2), @discount DECIMAL(19,2), @tax DECIMAL(19,2), @fulfill DECIMAL(19,2)

    -- re-price commodity lines against today's index (yes, on every call)
    EXEC dbo.usp_Price_CommodityPassThrough @orderID = @orderID

    SET @subtotal = dbo.fn_Order_Subtotal(@orderID)
    SELECT @discount = ISNULL(SUM(discountAmount), 0) FROM dbo.SwPromotionApplied WHERE orderID = @orderID OR orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    SELECT @tax = ISNULL(SUM(taxAmount), 0) FROM dbo.SwTaxApplied WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    SELECT @fulfill = ISNULL(SUM(fulfillmentCharge), 0) FROM dbo.SwOrderFulfillment WHERE orderID = @orderID

    UPDATE dbo.SwOrder SET calculatedTotal = @subtotal - @discount + @tax + @fulfill, modifiedDateTime = GETDATE() WHERE orderID = @orderID
END
GO
