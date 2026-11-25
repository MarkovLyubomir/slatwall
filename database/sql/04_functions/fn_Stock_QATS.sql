/* =============================================================================
   Function:  dbo.fn_Stock_QATS
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Quantity available to sell = QOH - open holds - unfulfilled order items.
   Change log:
     2014-04-22  WH   Initial version
     2019-10-08  PN   Subtract BOPIS holds (SwStockHold) - was double counting before
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Stock_QATS') IS NOT NULL DROP FUNCTION dbo.fn_Stock_QATS
GO
CREATE FUNCTION dbo.fn_Stock_QATS(@stockID CHAR(32))
RETURNS INT
AS
BEGIN
    DECLARE @qoh INT, @held INT, @open INT
    SET @qoh = dbo.fn_Stock_QOH(@stockID)
    SELECT @held = COUNT(*) FROM dbo.SwStockHold WHERE stockID = @stockID AND (stockHoldExpirationDateTime IS NULL OR stockHoldExpirationDateTime > GETDATE())
    SELECT @open = ISNULL(SUM(oi.quantity), 0)
    FROM dbo.SwOrderItem oi
    JOIN dbo.SwOrder o ON o.orderID = oi.orderID
    WHERE oi.stockID = @stockID
      AND o.orderStatusTypeID IN (dbo.fn_GetTypeID('orderStatusType','ostNew'), dbo.fn_GetTypeID('orderStatusType','ostProcessing'))
      AND oi.orderItemID NOT IN (SELECT orderItemID FROM dbo.SwOrderDeliveryItem WHERE orderItemID IS NOT NULL)
    RETURN @qoh - @held - @open
END
GO
