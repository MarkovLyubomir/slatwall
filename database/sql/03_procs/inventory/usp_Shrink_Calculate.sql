/* =============================================================================
   Procedure: dbo.usp_Shrink_Calculate
   Author:    Wade Hollister
   Created:   2021-01-18
   Purpose:   Shrink % of sales per store for a fiscal period: shrink events at
              cost / sales at retail (!). Target 0.42% (FIN-604).
   Change log:
     2021-01-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Shrink_Calculate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Shrink_Calculate
GO
CREATE PROCEDURE dbo.usp_Shrink_Calculate
    @fiscalYear SMALLINT,
    @fiscalPeriod TINYINT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE, @to DATE
    SELECT @from = MIN(CalendarDate), @to = MAX(CalendarDate) FROM dbo.SwFiscalCalendar WHERE FiscalYear = @fiscalYear AND FiscalPeriod = @fiscalPeriod
    SELECT sp.StoreNumber, sp.StoreName,
           ISNULL(sh.ShrinkCost, 0) AS ShrinkCost, ISNULL(sl.Sales, 0) AS Sales,
           CASE WHEN ISNULL(sl.Sales, 0) > 0 THEN ROUND(ISNULL(sh.ShrinkCost, 0) / sl.Sales * 100, 3) ELSE 0 END AS ShrinkPct,
           0.42 AS TargetPct, sh.OverrideCount
    FROM dbo.SwStoreProfile sp
    LEFT JOIN (SELECT StoreNumber, SUM(CostValue) AS ShrinkCost, SUM(CASE WHEN OverrideUser IS NOT NULL THEN 1 ELSE 0 END) AS OverrideCount FROM dbo.SwShrinkEvent WHERE EventDate BETWEEN @from AND @to GROUP BY StoreNumber) sh ON sh.StoreNumber = sp.StoreNumber
    LEFT JOIN (SELECT sp2.StoreNumber, SUM(o.calculatedTotal) AS Sales FROM dbo.SwOrder o JOIN dbo.SwStoreProfile sp2 ON sp2.locationID = o.locationID
               WHERE o.orderOpenDateTime BETWEEN @from AND @to AND o.orderTypeID = dbo.fn_GetTypeID('orderType','otSalesOrder') GROUP BY sp2.StoreNumber) sl ON sl.StoreNumber = sp.StoreNumber
    ORDER BY ShrinkPct DESC
END
GO
