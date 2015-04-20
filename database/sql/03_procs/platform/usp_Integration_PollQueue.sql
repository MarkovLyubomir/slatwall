/* =============================================================================
   Procedure: dbo.usp_Integration_PollQueue
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Called every 5 minutes by the file-transfer middleware: returns
              queued interface rows and marks them STARTED. No locking hints, so
              two pollers can take the same row (happened 2024-11-03).
   Change log:
     2015-04-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Integration_PollQueue', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Integration_PollQueue
GO
CREATE PROCEDURE dbo.usp_Integration_PollQueue
    @interfaceCode VARCHAR(20) = NULL,
    @max INT = 50
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP (@max) * INTO #batch FROM dbo.SwIntegrationQueue WHERE Status = 'QUEUED' AND (@interfaceCode IS NULL OR InterfaceCode = @interfaceCode) ORDER BY QueuedOn
    UPDATE q SET Status = 'STARTED', StartedOn = GETDATE() FROM dbo.SwIntegrationQueue q JOIN #batch b ON b.IntegrationQueueID = q.IntegrationQueueID
    SELECT * FROM #batch
    DROP TABLE #batch
END
GO
