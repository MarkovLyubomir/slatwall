/* =============================================================================
   Procedure: dbo.usp_Order_RemoveOrderPayment
   Author:    Wade Hollister
   Created:   2014-07-01
   Purpose:   Soft-remove a payment from an order (status opstRemoved).
   Change log:
     2014-07-01  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_RemoveOrderPayment', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_RemoveOrderPayment
GO
CREATE PROCEDURE dbo.usp_Order_RemoveOrderPayment
    @orderPaymentID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (SELECT 1 FROM dbo.SwPaymentTransaction WHERE orderPaymentID = @orderPaymentID AND transactionSuccessFlag = 1 AND amountReceived > 0)
    BEGIN
        RAISERROR('Payment has a successful charge; credit it instead', 16, 1)
        RETURN
    END
    UPDATE dbo.SwOrderPayment SET orderPaymentStatusTypeID = dbo.fn_GetTypeID('orderPaymentStatusType','opstRemoved'), modifiedDateTime = GETDATE() WHERE orderPaymentID = @orderPaymentID
END
GO
