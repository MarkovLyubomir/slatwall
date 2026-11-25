/* =============================================================================
   Procedure: dbo.usp_Order_UpdateStatus
   Author:    Wade Hollister
   Created:   2015-02-17
   Purpose:   Recompute order status from its items/fulfillments (New -> Processing -> Closed).
              Status machine lives in this CASE block and in three other procs.
   CUST-ID:   CUST-0044
   Change log:
     2015-02-17  WH   Initial version
     2018-01-09  WH   Partially delivered => Processing
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_UpdateStatus', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_UpdateStatus
GO
CREATE PROCEDURE dbo.usp_Order_UpdateStatus
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @cur VARCHAR(50) = dbo.fn_Order_StatusCode(@orderID), @new VARCHAR(50), @ordered INT, @delivered INT, @paid DECIMAL(19,2), @total DECIMAL(19,2)

    IF @cur IN ('ostNotPlaced','ostOnHold','ostCanceled','ostClosed') RETURN

    SELECT @ordered = ISNULL(SUM(quantity), 0) FROM dbo.SwOrderItem WHERE orderID = @orderID AND orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
    SELECT @delivered = ISNULL(SUM(odi.quantity), 0) FROM dbo.SwOrderDeliveryItem odi JOIN dbo.SwOrderItem oi ON oi.orderItemID = odi.orderItemID WHERE oi.orderID = @orderID
    SELECT @total = calculatedTotal FROM dbo.SwOrder WHERE orderID = @orderID
    SELECT @paid = ISNULL(SUM(pt.amountReceived), 0) FROM dbo.SwPaymentTransaction pt JOIN dbo.SwOrderPayment op ON op.orderPaymentID = pt.orderPaymentID WHERE op.orderID = @orderID
    -- terms orders count as paid when invoiced
    IF EXISTS (SELECT 1 FROM dbo.SwARInvoice WHERE orderID = @orderID) SET @paid = @total

    SET @new = CASE
        WHEN @delivered = 0 THEN 'ostNew'
        WHEN @delivered < @ordered THEN 'ostProcessing'
        WHEN @delivered >= @ordered AND @paid >= @total THEN 'ostClosed'
        ELSE 'ostProcessing' END

    IF @new <> @cur
    BEGIN
        UPDATE dbo.SwOrder SET orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType', @new),
                               orderCloseDateTime = CASE WHEN @new = 'ostClosed' THEN GETDATE() ELSE orderCloseDateTime END,
                               modifiedDateTime = GETDATE()
        WHERE orderID = @orderID
        INSERT dbo.SwOrderStatusLog (orderID, OldStatusCode, NewStatusCode, Source) VALUES (@orderID, @cur, @new, 'usp_Order_UpdateStatus')
    END
END
GO
