/* =============================================================================
   Procedure: dbo.usp_Delivery_ImportPOD
   Author:    Priscilla Nance
   Created:   2022-03-01
   Purpose:   Proof-of-delivery from Descartes: close the stop, post inventory out,
              compute on-time, update order status, first-delivery for liens.
   Change log:
     2022-03-01  PN   Initial version
     2023-08-21  WH   Lien first-delivery hook
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Delivery_ImportPOD', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Delivery_ImportPOD
GO
CREATE PROCEDURE dbo.usp_Delivery_ImportPOD
    @deliveryStopID INT,
    @arrivedOn DATETIME,
    @completedOn DATETIME,
    @signature VARCHAR(100) = NULL,
    @photoRef VARCHAR(200) = NULL,
    @exceptionCode VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @deliveryID CHAR(32), @windowEnd DATETIME, @jobAccountID INT
    SELECT @orderID = orderID, @deliveryID = orderDeliveryID, @windowEnd = WindowEnd FROM dbo.SwDeliveryStop WHERE DeliveryStopID = @deliveryStopID
    UPDATE dbo.SwDeliveryStop SET ArrivedOn = @arrivedOn, CompletedOn = @completedOn, PODSignature = @signature, PODPhotoRef = @photoRef, ExceptionCode = @exceptionCode,
                                  OnTimeFlag = CASE WHEN @windowEnd IS NULL OR @arrivedOn <= @windowEnd THEN 1 ELSE 0 END
    WHERE DeliveryStopID = @deliveryStopID
    IF @exceptionCode IS NULL AND @deliveryID IS NOT NULL
    BEGIN
        INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, orderDeliveryItemID)
        SELECT dbo.fn_NewID32(), 0, odi.quantity, @completedOn, odi.stockID, odi.orderDeliveryItemID FROM dbo.SwOrderDeliveryItem odi
        WHERE odi.orderDeliveryID = @deliveryID AND NOT EXISTS (SELECT 1 FROM dbo.SwInventory i WHERE i.orderDeliveryItemID = odi.orderDeliveryItemID)
        UPDATE dbo.SwOrderFulfillment SET orderFulfillmentStatusTypeID = dbo.fn_GetTypeID('orderFulfillmentStatusType','ofstFulfilled') WHERE orderID = @orderID
        EXEC dbo.usp_Order_UpdateStatus @orderID
        SELECT TOP 1 @jobAccountID = JobAccountID FROM dbo.SwWillCallRelease WHERE orderID = @orderID
        IF @jobAccountID IS NOT NULL EXEC dbo.usp_Lien_CalcNoticeDeadline @jobAccountID
    END
END
GO
