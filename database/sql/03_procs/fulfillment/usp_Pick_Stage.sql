/* =============================================================================
   Procedure: dbo.usp_Pick_Stage
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Mark a pick staged in a bay and notify the customer (email queue).
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pick_Stage', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pick_Stage
GO
CREATE PROCEDURE dbo.usp_Pick_Stage
    @pickTaskID INT,
    @stagingBay VARCHAR(10),
    @stagedBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @email VARCHAR(255)
    UPDATE dbo.SwPickTask SET PickStatus = 'STAGED', PickCompletedOn = ISNULL(PickCompletedOn, GETDATE()), StagedOn = GETDATE(), StagingBay = @stagingBay, AssignedTo = @stagedBy WHERE PickTaskID = @pickTaskID
    SELECT @orderID = f.orderID, @email = f.emailAddress FROM dbo.SwPickTask p JOIN dbo.SwOrderFulfillment f ON f.orderFulfillmentID = p.orderFulfillmentID WHERE p.PickTaskID = @pickTaskID
    UPDATE dbo.SwOrderFulfillment SET orderFulfillmentStatusTypeID = dbo.fn_GetTypeID('orderFulfillmentStatusType','ofstPartiallyFulfilled') WHERE orderID = @orderID
    EXEC dbo.usp_Email_AddToQueue @emailTo = @email, @templateCode = 'BOPIS_READY', @relatedObject = 'Order', @relatedObjectID = @orderID
    UPDATE dbo.SwPickTask SET CustomerNotifiedOn = GETDATE() WHERE PickTaskID = @pickTaskID
END
GO
