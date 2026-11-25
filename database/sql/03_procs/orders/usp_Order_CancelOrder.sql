/* =============================================================================
   Procedure: dbo.usp_Order_CancelOrder
   Author:    Wade Hollister
   Created:   2014-09-02
   Purpose:   Cancel an order: release holds, void payments, log.
   Change log:
     2014-09-02  WH   Initial version
     2019-10-08  PN   Cancel pick tasks
     2022-03-01  PN   Cancel delivery stops
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_CancelOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_CancelOrder
GO
CREATE PROCEDURE dbo.usp_Order_CancelOrder
    @orderID CHAR(32),
    @reason VARCHAR(200) = NULL,
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @status VARCHAR(50) = dbo.fn_Order_StatusCode(@orderID)
    IF @status IN ('ostClosed','ostCanceled')
    BEGIN
        RAISERROR('Order cannot be canceled from status %s', 16, 1, @status)
        RETURN
    END
    IF EXISTS (SELECT 1 FROM dbo.SwOrderDeliveryItem odi JOIN dbo.SwOrderItem oi ON oi.orderItemID = odi.orderItemID WHERE oi.orderID = @orderID)
    BEGIN
        RAISERROR('Order has deliveries; create a return instead', 16, 1)
        RETURN
    END
    BEGIN TRAN
    DELETE dbo.SwStockHold WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    UPDATE dbo.SwPickTask SET PickStatus = 'CANCELED' WHERE orderFulfillmentID IN (SELECT orderFulfillmentID FROM dbo.SwOrderFulfillment WHERE orderID = @orderID)
    UPDATE dbo.SwDeliveryStop SET ExceptionCode = 'CANC' WHERE orderID = @orderID AND CompletedOn IS NULL
    UPDATE dbo.SwOrderPayment SET orderPaymentStatusTypeID = dbo.fn_GetTypeID('orderPaymentStatusType','opstRemoved') WHERE orderID = @orderID
    UPDATE dbo.SwARInvoice SET Status = 'VOID' WHERE orderID = @orderID AND PaidAmount = 0
    UPDATE dbo.SwOrder SET orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostCanceled'), orderCloseDateTime = GETDATE(), modifiedDateTime = GETDATE() WHERE orderID = @orderID
    INSERT dbo.SwOrderStatusLog (orderID, OldStatusCode, NewStatusCode, ChangedBy, Source) VALUES (@orderID, @status, 'ostCanceled', @byUser, ISNULL(@reason, 'usp_Order_CancelOrder'))
    COMMIT
END
GO
