/* =============================================================================
   Procedure: dbo.usp_Rpt_ShrinkRunRate
   Author:    Wade Hollister
   Created:   2021-01-18
   Purpose:   Wrapper for the weekly KPI pack: current fiscal period shrink.
   Change log:
     2021-01-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_ShrinkRunRate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_ShrinkRunRate
GO
CREATE PROCEDURE dbo.usp_Rpt_ShrinkRunRate
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @fy SMALLINT, @fp TINYINT
    SELECT @fy = FiscalYear, @fp = FiscalPeriod FROM dbo.SwFiscalCalendar WHERE CalendarDate = CAST(GETDATE() AS DATE)
    IF @fy IS NULL BEGIN SET @fy = dbo.fn_FiscalYear(GETDATE()) SET @fp = (dbo.fn_FiscalWeek(GETDATE()) - 1) / 4 + 1 END
    EXEC dbo.usp_Shrink_Calculate @fiscalYear = @fy, @fiscalPeriod = @fp
END
GO
