/* =============================================================================
   Function:  dbo.clr_AdyenAuthorize
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   DEV/TEST STUB for the CLR assembly SlatwallPayBridge (UNSAFE, not
              deployable outside production). Returns a fake approval so the
              checkout path can be exercised. In production this object is the
              CLR function with the same signature.
   Change log:
     2018-11-26  PN   Stub for non-prod
   ============================================================================= */
IF OBJECT_ID('dbo.clr_AdyenAuthorize') IS NOT NULL DROP FUNCTION dbo.clr_AdyenAuthorize
GO
CREATE FUNCTION dbo.clr_AdyenAuthorize(@merchantRef CHAR(32), @amountMinor BIGINT, @timeoutSec INT)
RETURNS NVARCHAR(400)
AS
BEGIN
    IF @amountMinor <= 0 RETURN N'ERR|Invalid amount'
    RETURN N'OK|STUB' + RIGHT(@merchantRef, 10) + N'|A' + RIGHT(@merchantRef, 5)
END
GO
