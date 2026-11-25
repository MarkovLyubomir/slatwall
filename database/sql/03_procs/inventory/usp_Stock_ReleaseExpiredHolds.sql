/* =============================================================================
   Procedure: dbo.usp_Stock_ReleaseExpiredHolds
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Delete expired holds. Scheduled weekdays 06:00 only (SQL Agent job
              "SWC - Release Holds", Mon-Fri).
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_ReleaseExpiredHolds', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_ReleaseExpiredHolds
GO
CREATE PROCEDURE dbo.usp_Stock_ReleaseExpiredHolds
AS
BEGIN
    SET NOCOUNT ON
    DELETE dbo.SwStockHold WHERE stockHoldExpirationDateTime < GETDATE()
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Stock_ReleaseExpiredHolds', 'release', @@ROWCOUNT, 'OK', GETDATE())
END
GO
