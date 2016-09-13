/* =============================================================================
   Function:  dbo.fn_Lien_StateDeadlineDays
   Author:    Wade Hollister
   Created:   2016-09-13
   Purpose:   Days from first furnishing to preliminary notice / lien filing deadline.
   WARNING:   Statutory. Values maintained by Legal in SAL-106 §6.2; this function
              is a copy and has drifted (TN corrected Aug 2026, see change log).
   Change log:
     2016-09-13  WH   Initial version (NC, SC, VA)
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Lien_StateDeadlineDays') IS NOT NULL DROP FUNCTION dbo.fn_Lien_StateDeadlineDays
GO
CREATE FUNCTION dbo.fn_Lien_StateDeadlineDays(@stateCode CHAR(2), @noticeType VARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN CASE
        WHEN @stateCode = 'NC' AND @noticeType = 'NTO'   THEN 0      -- NC: notice to lien agent before/at first furnishing (simplified)
        WHEN @stateCode = 'NC' AND @noticeType = 'LIEN'  THEN 120
        WHEN @stateCode = 'SC' AND @noticeType = 'NTO'   THEN 0      -- SC: notice of furnishing (simplified)
        WHEN @stateCode = 'SC' AND @noticeType = 'LIEN'  THEN 90
        WHEN @stateCode = 'VA' AND @noticeType = 'NTO'   THEN 30
        WHEN @stateCode = 'VA' AND @noticeType = 'LIEN'  THEN 90
        WHEN @stateCode = 'TN' AND @noticeType = 'NTO'   THEN 90     -- corrected 2026-08-03 (was 60)
        WHEN @stateCode = 'TN' AND @noticeType = 'LIEN'  THEN 90
        ELSE 60 END
END
GO
