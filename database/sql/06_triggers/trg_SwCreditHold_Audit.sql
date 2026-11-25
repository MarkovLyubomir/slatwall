/* =============================================================================
   Trigger:   dbo.trg_SwCreditHold_Audit
   Author:    Wade Hollister
   Created:   2026-06-29
   Purpose:   AUD-210 remediation: write override events to the ETL log so
              Internal Audit can count them without SELECT on SwCreditHold.
   Change log:
     2026-06-29  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwCreditHold_Audit', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwCreditHold_Audit
GO
CREATE TRIGGER dbo.trg_SwCreditHold_Audit ON dbo.SwCreditHold
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON
    INSERT dbo.SwETL_Log (JobName, StepName, Status, Message, RunBy)
    SELECT 'CreditHoldOverride', 'store ' + CAST(OverrideStore AS VARCHAR(3)), 'AUDIT', 'account ' + CAST(ProAccountID AS VARCHAR(10)) + ' code ' + ISNULL(OverrideJustificationCode, '-'), HoldBy
    FROM inserted WHERE OverrideFlag = 1
END
GO
