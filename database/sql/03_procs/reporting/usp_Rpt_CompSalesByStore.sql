/* =============================================================================
   Procedure: dbo.usp_Rpt_CompSalesByStore
   Author:    Priscilla Nance
   Created:   2017-02-06
   Purpose:   Comparable sales by store, week over prior-year week. Comp
              definition #1: stores open > 12 months, all channels attributed to
              the stocking location, includes tax and delivery (calculatedTotal).
   Change log:
     2017-02-06  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_CompSalesByStore', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_CompSalesByStore
GO
CREATE PROCEDURE dbo.usp_Rpt_CompSalesByStore
    @fiscalYear SMALLINT,
    @fiscalWeek TINYINT
AS
BEGIN
    SET NOCOUNT ON
    SELECT sp.StoreNumber, sp.StoreName, sp.Region,
           SUM(CASE WHEN dbo.fn_FiscalYear(o.orderOpenDateTime) = @fiscalYear THEN o.calculatedTotal ELSE 0 END) AS ThisYear,
           SUM(CASE WHEN dbo.fn_FiscalYear(o.orderOpenDateTime) = @fiscalYear - 1 THEN o.calculatedTotal ELSE 0 END) AS LastYear,
           CASE WHEN SUM(CASE WHEN dbo.fn_FiscalYear(o.orderOpenDateTime) = @fiscalYear - 1 THEN o.calculatedTotal ELSE 0 END) > 0
                THEN ROUND(100.0 * (SUM(CASE WHEN dbo.fn_FiscalYear(o.orderOpenDateTime) = @fiscalYear THEN o.calculatedTotal ELSE 0 END)
                                   / SUM(CASE WHEN dbo.fn_FiscalYear(o.orderOpenDateTime) = @fiscalYear - 1 THEN o.calculatedTotal ELSE 0 END) - 1), 2) END AS CompPct
    FROM dbo.SwOrder o WITH (NOLOCK)
    JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
    WHERE dbo.fn_FiscalWeek(o.orderOpenDateTime) = @fiscalWeek
      AND dbo.fn_FiscalYear(o.orderOpenDateTime) IN (@fiscalYear, @fiscalYear - 1)
      AND o.orderStatusTypeID NOT IN (SELECT typeID FROM dbo.SwType WHERE systemCode IN ('ostNotPlaced','ostCanceled'))
      AND sp.OpenDate < DATEADD(MONTH, -12, DATEFROMPARTS(@fiscalYear, 2, 1))
    GROUP BY sp.StoreNumber, sp.StoreName, sp.Region
    ORDER BY sp.StoreNumber
END
GO
