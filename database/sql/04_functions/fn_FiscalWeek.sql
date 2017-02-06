/* =============================================================================
   Function:  dbo.fn_FiscalWeek
   Author:    Priscilla Nance
   Created:   2017-02-06
   Purpose:   Fiscal week number for a date. FY runs 1 Feb - 31 Jan.
   NOTE:      SwFiscalCalendar was added in 2019 but this function still computes
              the week arithmetically; the two disagree in 53-week years (FY2023).
   Change log:
     2017-02-06  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_FiscalWeek') IS NOT NULL DROP FUNCTION dbo.fn_FiscalWeek
GO
CREATE FUNCTION dbo.fn_FiscalWeek(@d DATE)
RETURNS TINYINT
AS
BEGIN
    DECLARE @fyStart DATE
    SET @fyStart = DATEFROMPARTS(CASE WHEN MONTH(@d) = 1 THEN YEAR(@d) - 1 ELSE YEAR(@d) END, 2, 1)
    RETURN CAST(DATEDIFF(DAY, @fyStart, @d) / 7 + 1 AS TINYINT)
END
GO
