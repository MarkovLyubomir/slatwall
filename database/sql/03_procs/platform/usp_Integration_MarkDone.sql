/* =============================================================================
   Procedure: dbo.usp_Integration_MarkDone
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Middleware callback.
   Change log:
     2015-04-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Integration_MarkDone', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Integration_MarkDone
GO
CREATE PROCEDURE dbo.usp_Integration_MarkDone
    @integrationQueueID BIGINT,
    @ok BIT,
    @errorText VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwIntegrationQueue SET Status = CASE WHEN @ok = 1 THEN 'DONE' ELSE 'ERROR' END, FinishedOn = GETDATE(), ErrorText = CASE WHEN @ok = 1 THEN ErrorText ELSE @errorText END,
                                      RetryCount = CASE WHEN @ok = 1 THEN RetryCount ELSE RetryCount + 1 END
    WHERE IntegrationQueueID = @integrationQueueID
    IF @ok = 0 AND (SELECT RetryCount FROM dbo.SwIntegrationQueue WHERE IntegrationQueueID = @integrationQueueID) < 3
        UPDATE dbo.SwIntegrationQueue SET Status = 'QUEUED' WHERE IntegrationQueueID = @integrationQueueID
END
GO
