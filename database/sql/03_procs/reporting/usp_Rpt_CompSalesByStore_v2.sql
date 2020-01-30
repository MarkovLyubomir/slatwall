/* =============================================================================
   Procedure: dbo.usp_Rpt_CompSalesByStore_v2
   Author:    Priscilla Nance
   Created:   2020-01-30
   Purpose:   Comp sales v2 for the Monday ops call. Definition #2: merchandise
              only (fn_Order_Subtotal, no tax/delivery), web orders attributed
              to the pickup/ship-from store, uses SwFiscalCalendar comp weeks.
              Both v1 and v2 are still on the Power BI report.
   Change log:
     2020-01-30  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_CompSalesByStore_v2', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_CompSalesByStore_v2
GO
CREATE PROCEDURE dbo.usp_Rpt_CompSalesByStore_v2
    @fiscalYear SMALLINT,
    @fiscalWeek TINYINT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE, @to DATE, @lyFrom DATE, @lyTo DATE
    SELECT @from = MIN(CalendarDate), @to = MAX(CalendarDate), @lyFrom = MIN(CompWeekDate), @lyTo = MAX(CompWeekDate) FROM dbo.SwFiscalCalendar WHERE FiscalYear = @fiscalYear AND FiscalWeek = @fiscalWeek

    SELECT * INTO #ty FROM (
        SELECT ISNULL(sp.StoreNumber, 0) AS StoreNumber, SUM(dbo.fn_Order_Subtotal(o.orderID)) AS Sales
        FROM dbo.SwOrder o WITH (NOLOCK) LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
        WHERE CAST(o.orderOpenDateTime AS DATE) BETWEEN @from AND @to AND o.orderNumber IS NOT NULL GROUP BY sp.StoreNumber) x
    SELECT * INTO #ly FROM (
        SELECT ISNULL(sp.StoreNumber, 0) AS StoreNumber, SUM(dbo.fn_Order_Subtotal(o.orderID)) AS Sales
        FROM dbo.SwOrder o WITH (NOLOCK) LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
        WHERE CAST(o.orderOpenDateTime AS DATE) BETWEEN @lyFrom AND @lyTo AND o.orderNumber IS NOT NULL GROUP BY sp.StoreNumber) x

    SELECT sp.StoreNumber, sp.StoreName, sp.Region, ISNULL(ty.Sales, 0) AS ThisYear, ISNULL(ly.Sales, 0) AS LastYear,
           CASE WHEN ISNULL(ly.Sales, 0) > 0 THEN ROUND(100.0 * (ISNULL(ty.Sales, 0) / ly.Sales - 1), 2) END AS CompPct,
           CASE WHEN sp.OpenDate < DATEADD(MONTH, -13, @from) THEN 'COMP' ELSE 'NON-COMP' END AS CompStatus
    FROM dbo.SwStoreProfile sp LEFT JOIN #ty ty ON ty.StoreNumber = sp.StoreNumber LEFT JOIN #ly ly ON ly.StoreNumber = sp.StoreNumber
    ORDER BY sp.StoreNumber
    DROP TABLE #ty
    DROP TABLE #ly
END
GO
