/* =============================================================================
   Function:  dbo.fn_Order_Subtotal
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Sum of sale line extended prices for an order.
   Change log:
     2014-06-12  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Order_Subtotal') IS NOT NULL DROP FUNCTION dbo.fn_Order_Subtotal
GO
CREATE FUNCTION dbo.fn_Order_Subtotal(@orderID CHAR(32))
RETURNS DECIMAL(19,2)
AS
BEGIN
    RETURN (SELECT ISNULL(SUM(oi.price * oi.quantity), 0) FROM dbo.SwOrderItem oi
            WHERE oi.orderID = @orderID AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale'))
END
GO
