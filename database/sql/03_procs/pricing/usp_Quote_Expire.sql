/* =============================================================================
   Procedure: dbo.usp_Quote_Expire
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Nightly: expire issued quotes past ValidUntil.
   Change log:
     2016-03-14  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_Expire', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_Expire
GO
CREATE PROCEDURE dbo.usp_Quote_Expire
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwQuote SET QuoteStatus = 'EXPIRED', UpdatedOn = GETDATE(), UpdatedBy = 'nightly'
    WHERE QuoteStatus = 'ISSUED' AND ValidUntil < CAST(GETDATE() AS DATE)
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Quote_Expire', 'expire', @@ROWCOUNT, 'OK', GETDATE())
END
GO
