/* =============================================================================
   Function:  dbo.fn_FiscalYear
   Author:    Priscilla Nance
   Created:   2017-02-06
   Purpose:   Fiscal year for a date (FY named for the calendar year it starts in).
   Change log:
     2017-02-06  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_FiscalYear') IS NOT NULL DROP FUNCTION dbo.fn_FiscalYear
GO
CREATE FUNCTION dbo.fn_FiscalYear(@d DATE)
RETURNS SMALLINT
AS
BEGIN
    RETURN CASE WHEN MONTH(@d) = 1 THEN YEAR(@d) - 1 ELSE YEAR(@d) END
END
GO
