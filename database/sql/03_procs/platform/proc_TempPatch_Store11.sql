/* =============================================================================
   Procedure: dbo.proc_TempPatch_Store11
   Author:    Wade Hollister
   Created:   2026-06-03
   Purpose:   TEMPORARY - zero out the QNC cache at store 11 after the Q1 audit
              count so the web stops showing damaged stock as available.
              Hard-codes the Charleston location id. Remove after AUD-210 remediation.
   Change log:
     2026-06-03  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.proc_TempPatch_Store11', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_TempPatch_Store11
GO
CREATE PROCEDURE dbo.proc_TempPatch_Store11
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwStock SET calculatedQNC = 0, calculatedQATS = calculatedQOH WHERE locationID = '4f3c2d1e8a7b4c6d9e0f1a2b3c4d5e6f'   -- store 11 Charleston
END
GO
