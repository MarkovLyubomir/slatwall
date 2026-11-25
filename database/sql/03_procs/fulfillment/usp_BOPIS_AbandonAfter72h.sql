/* =============================================================================
   Procedure: dbo.usp_BOPIS_AbandonAfter72h
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   OPS-202 §5: staged BOPIS orders not collected in 72h are abandoned,
              holds released, order canceled and card refunded (by the app).
              Scheduled Mon-Fri 06:00 - weekend pickups age two extra days.
   NOTE:      No transaction; if the cancel fails the holds are already gone.
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_BOPIS_AbandonAfter72h', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_BOPIS_AbandonAfter72h
GO
CREATE PROCEDURE dbo.usp_BOPIS_AbandonAfter72h
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pickTaskID INT, @orderID CHAR(32), @fID CHAR(32)
    DECLARE c CURSOR LOCAL FOR
        SELECT p.PickTaskID, f.orderID, f.orderFulfillmentID FROM dbo.SwPickTask p JOIN dbo.SwOrderFulfillment f ON f.orderFulfillmentID = p.orderFulfillmentID
        WHERE p.PickStatus = 'STAGED' AND p.StagedOn < DATEADD(HOUR, -72, GETDATE()) AND p.FulfillType = 'BOPIS'
    OPEN c
    FETCH NEXT FROM c INTO @pickTaskID, @orderID, @fID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE dbo.SwStockHold WHERE orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderFulfillmentID = @fID)
        UPDATE dbo.SwPickTask SET PickStatus = 'ABANDONED', AbandonedOn = GETDATE() WHERE PickTaskID = @pickTaskID
        EXEC dbo.usp_Order_CancelOrder @orderID = @orderID, @reason = 'BOPIS abandoned 72h', @byUser = 'nightly'
        FETCH NEXT FROM c INTO @pickTaskID, @orderID, @fID
    END
    CLOSE c DEALLOCATE c
END
GO
