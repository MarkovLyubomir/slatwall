/* =============================================================================
   Procedure: dbo.usp_Audit_Purge
   Author:    Wade Hollister
   Created:   2015-06-08
   Purpose:   Purge SwAudit rows older than 24 months. Single DELETE on a 400GB
              table with no index on auditDateTime; times out most nights and
              the batch continues (the TRY/CATCH swallows it).
   Change log:
     2015-06-08  WH   Initial version
     2020-09-14  WH   Wrapped in TRY/CATCH so it stops failing the batch
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Audit_Purge', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Audit_Purge
GO
CREATE PROCEDURE dbo.usp_Audit_Purge
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET LOCK_TIMEOUT 300000
        DELETE dbo.SwAudit WHERE auditDateTime < DATEADD(MONTH, -24, GETDATE())
        INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Audit_Purge', 'purge', @@ROWCOUNT, 'OK', GETDATE())
    END TRY
    BEGIN CATCH
        INSERT dbo.SwETL_Log (JobName, StepName, Status, Message, FinishedOn) VALUES ('usp_Audit_Purge', 'purge', 'WARN', ERROR_MESSAGE(), GETDATE())
    END CATCH
END
GO
