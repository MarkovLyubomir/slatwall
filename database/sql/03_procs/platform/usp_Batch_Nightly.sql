/* =============================================================================
   Procedure: dbo.usp_Batch_Nightly
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   The nightly batch orchestrator (SQL Agent job "SWC - Nightly",
              22:30). Steps run in sequence; a failure in step 5 (RecalcStock)
              leaves steps 6-14 unrun and there is no restart-from-step.
              Window is supposed to close by 03:10 for the web inventory feed.
   CUST-ID:   CUST-0021
   Change log:
     2014-04-22  WH   Initial version (4 steps)
     2015-04-20  WH   BT customer + item import
     2016-11-07  WH   Zone prices
     2018-11-26  PN   Web price book + inventory + product
     2019-10-08  PN   BOPIS abandonment
     2021-01-18  WH   Cycle count schedule (weekly, Sunday)
     2022-11-07  PN   Akeneo export
     2024-02-05  WH   Retier (1 Feb only)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Batch_Nightly', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Batch_Nightly
GO
CREATE PROCEDURE dbo.usp_Batch_Nightly
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @start DATETIME = GETDATE(), @step VARCHAR(60), @msg VARCHAR(4000)
    INSERT dbo.SwETL_Log (JobName, StepName, Status) VALUES ('usp_Batch_Nightly', 'start', 'RUNNING')
    BEGIN TRY
        SET @step = '01 Account_SyncFromBisTrack';  EXEC dbo.usp_Account_SyncFromBisTrack
        SET @step = '02 Catalog_ImportFromBisTrack'; EXEC dbo.usp_Catalog_ImportFromBisTrack
        SET @step = '03 Price_ImportZonePrices';    DECLARE @today DATE = CAST(GETDATE() AS DATE); EXEC dbo.usp_Price_ImportZonePrices @today
        SET @step = '04 Stock_ReleaseExpiredHolds'; EXEC dbo.usp_Stock_ReleaseExpiredHolds
        SET @step = '05 Batch_RecalcStock';         EXEC dbo.usp_Batch_RecalcStock
        SET @step = '06 Web_SyncInventory';         EXEC dbo.usp_Web_SyncInventory
        SET @step = '07 Web_SyncPriceBook';         EXEC dbo.usp_Web_SyncPriceBook
        SET @step = '08 Web_SyncProduct';           EXEC dbo.usp_Web_SyncProduct
        SET @step = '09 Quote_Expire';              EXEC dbo.usp_Quote_Expire
        SET @step = '10 BOPIS_AbandonAfter72h';     EXEC dbo.usp_BOPIS_AbandonAfter72h
        SET @step = '11 Credit_AgeReceivables';     EXEC dbo.usp_Credit_AgeReceivables
        SET @step = '12 Credit_RunDunning';         EXEC dbo.usp_Credit_RunDunning
        SET @step = '13 Billtrust';                 EXEC dbo.usp_Billtrust_ExportInvoices; EXEC dbo.usp_Billtrust_ImportPayments
        SET @step = '14 Catalog_ExportToAkeneo';    EXEC dbo.usp_Catalog_ExportToAkeneo
        IF DATEPART(WEEKDAY, GETDATE()) = 1 BEGIN SET @step = '15 CycleCount_Schedule'; EXEC dbo.usp_CycleCount_Schedule END
        IF MONTH(GETDATE()) = 2 AND DAY(GETDATE()) = 1 BEGIN SET @step = '16 Pro_RetierAccounts'; EXEC dbo.usp_Pro_RetierAccounts @dryRun = 0 END
        SET @step = '17 Audit_Purge';               EXEC dbo.usp_Audit_Purge
        SET @step = '18 Session_Cleanup';           EXEC dbo.usp_Session_Cleanup
        SET @step = '19 Snowflake_ExtractDelta';    EXEC dbo.usp_Snowflake_ExtractDelta
        INSERT dbo.SwETL_Log (JobName, StepName, StartedOn, FinishedOn, Status) VALUES ('usp_Batch_Nightly', 'end', @start, GETDATE(), 'OK')
    END TRY
    BEGIN CATCH
        SET @msg = ERROR_MESSAGE()
        IF @@TRANCOUNT > 0 ROLLBACK
        INSERT dbo.SwETL_Log (JobName, StepName, StartedOn, FinishedOn, Status, Message) VALUES ('usp_Batch_Nightly', @step, @start, GETDATE(), 'FAILED', @msg)
        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'SWC', @recipients = 'wade.hollister@slatwall.com;pnance@slatwall.com', @subject = 'SWC nightly FAILED', @body = @msg
    END CATCH
END
GO
