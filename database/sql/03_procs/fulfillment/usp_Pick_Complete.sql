/* =============================================================================
   Procedure: dbo.usp_Pick_Complete
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Customer picked up: verify ID type, create the delivery (ledger out),
              release holds, close the task.
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pick_Complete', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pick_Complete
GO
CREATE PROCEDURE dbo.usp_Pick_Complete
    @pickTaskID INT,
    @verifiedIDType VARCHAR(20),
    @handedBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @fID CHAR(32), @locationID CHAR(32), @deliveryID CHAR(32)
    SELECT @orderID = f.orderID, @fID = f.orderFulfillmentID, @locationID = f.locationID FROM dbo.SwPickTask p JOIN dbo.SwOrderFulfillment f ON f.orderFulfillmentID = p.orderFulfillmentID WHERE p.PickTaskID = @pickTaskID
    EXEC dbo.usp_Delivery_Create @orderID = @orderID, @orderFulfillmentID = @fID, @locationID = @locationID, @postInventory = 1, @orderDeliveryID = @deliveryID OUTPUT
    DELETE dbo.SwStockHold WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderFulfillmentID = @fID)
    UPDATE dbo.SwPickTask SET PickStatus = 'COMPLETE', PickedUpOn = GETDATE(), VerifiedIDType = @verifiedIDType, AssignedTo = @handedBy WHERE PickTaskID = @pickTaskID
    UPDATE dbo.SwOrderFulfillment SET orderFulfillmentStatusTypeID = dbo.fn_GetTypeID('orderFulfillmentStatusType','ofstFulfilled') WHERE orderFulfillmentID = @fID
    EXEC dbo.usp_Order_UpdateStatus @orderID
END
GO
