/* =============================================================================
   Procedure: dbo.usp_KPI_WeeklySnapshot
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Monday 05:00: write the FIN-604 weekly KPIs into SwKPI_Snapshot by
              running the report procs into temp tables. Runs ~55 minutes on
              production during the batch window.
   Change log:
     2019-06-17  PN   Initial version
     2022-03-01  PN   On-time delivery
     2024-04-08  PN   CalcVersion tag so Snowflake can tell v1/v2 comp apart
   ============================================================================= */
IF OBJECT_ID('dbo.usp_KPI_WeeklySnapshot', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_KPI_WeeklySnapshot
GO
CREATE PROCEDURE dbo.usp_KPI_WeeklySnapshot
    @fiscalYear SMALLINT = NULL,
    @fiscalWeek TINYINT = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE, @to DATE
    IF @fiscalYear IS NULL SET @fiscalYear = dbo.fn_FiscalYear(DATEADD(DAY, -7, GETDATE()))
    IF @fiscalWeek IS NULL SET @fiscalWeek = dbo.fn_FiscalWeek(DATEADD(DAY, -7, GETDATE()))
    SELECT @from = MIN(CalendarDate), @to = MAX(CalendarDate) FROM dbo.SwFiscalCalendar WHERE FiscalYear = @fiscalYear AND FiscalWeek = @fiscalWeek
    IF @from IS NULL BEGIN SET @to = CAST(GETDATE() AS DATE) SET @from = DATEADD(DAY, -6, @to) END
    DELETE dbo.SwKPI_Snapshot WHERE FiscalYear = @fiscalYear AND FiscalWeek = @fiscalWeek AND KPICode NOT IN ('PRO_DSO')

    CREATE TABLE #comp (StoreNumber TINYINT, StoreName VARCHAR(60), Region VARCHAR(20), ThisYear DECIMAL(19,2), LastYear DECIMAL(19,2), CompPct DECIMAL(9,2))
    INSERT #comp EXEC dbo.usp_Rpt_CompSalesByStore @fiscalYear, @fiscalWeek
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, StoreNumber, 'ALL', 'COMP_SALES_PCT', CompPct, 'v1' FROM #comp
    DELETE #comp
    CREATE TABLE #comp2 (StoreNumber TINYINT, StoreName VARCHAR(60), Region VARCHAR(20), ThisYear DECIMAL(19,2), LastYear DECIMAL(19,2), CompPct DECIMAL(9,2), CompStatus VARCHAR(10))
    INSERT #comp2 EXEC dbo.usp_Rpt_CompSalesByStore_v2 @fiscalYear, @fiscalWeek
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, StoreNumber, 'ALL', 'COMP_SALES_PCT', CompPct, 'v2' FROM #comp2 WHERE CompStatus = 'COMP'

    CREATE TABLE #gm (Category VARCHAR(255), Sales DECIMAL(19,2), Cost DECIMAL(19,2), GrossMargin DECIMAL(19,2), GMPct DECIMAL(9,2), PrivateLabelSales DECIMAL(19,2))
    INSERT #gm EXEC dbo.usp_Rpt_GrossMarginByCategory @from, @to
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion)
    SELECT @fiscalYear, @fiscalWeek, NULL, 'ALL', 'GM_PCT', CASE WHEN SUM(Sales) > 0 THEN 100.0 * SUM(GrossMargin) / SUM(Sales) END, 26.8, 'v1' FROM #gm
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion)
    SELECT @fiscalYear, @fiscalWeek, NULL, 'ALL', 'PL_PENETRATION_PCT', CASE WHEN SUM(Sales) > 0 THEN 100.0 * SUM(PrivateLabelSales) / SUM(Sales) END, 20.0, 'v1' FROM #gm

    CREATE TABLE #turns (StoreNumber TINYINT, StoreName VARCHAR(60), COGS_TTM DECIMAL(19,2), AvgInventoryCost DECIMAL(19,2), Turns DECIMAL(9,2), Target DECIMAL(5,2))
    INSERT #turns EXEC dbo.usp_Rpt_InventoryTurns @to
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, StoreNumber, 'STORE', 'INV_TURNS', Turns, 6.2, 'v1' FROM #turns

    CREATE TABLE #fill (Region VARCHAR(20), StoreNumber TINYINT, Lines INT, FilledLines INT, FillRatePct DECIMAL(9,2), Target DECIMAL(5,2))
    INSERT #fill EXEC dbo.usp_Rpt_FillRate @from, @to
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, StoreNumber, 'STORE', 'FILL_RATE_PCT', FillRatePct, 96.0, 'v1' FROM #fill

    CREATE TABLE #otd (Region VARCHAR(20), Stops INT, OnTime INT, OnTimePct DECIMAL(9,2), Target DECIMAL(5,2), AvgFee DECIMAL(19,2), BoomStops INT)
    INSERT #otd EXEC dbo.usp_Rpt_OnTimeDelivery @from, @to
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, NULL, Region, 'ON_TIME_DELIVERY_PCT', OnTimePct, 94.0, 'v1' FROM #otd

    CREATE TABLE #conv (CartSessions INT, WebOrders INT, ConversionPct DECIMAL(9,2), Target DECIMAL(5,2))
    INSERT #conv EXEC dbo.usp_Rpt_DigitalConversion @from, @to
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion) SELECT @fiscalYear, @fiscalWeek, NULL, 'WEB', 'DIGITAL_CONVERSION_PCT', ConversionPct, 2.10, 'v1' FROM #conv

    EXEC dbo.usp_Credit_CalcDSO @to
    INSERT dbo.SwETL_Log (JobName, StepName, Status, FinishedOn, Message) VALUES ('usp_KPI_WeeklySnapshot', 'week ' + CAST(@fiscalWeek AS VARCHAR(3)), 'OK', GETDATE(), NULL)
END
GO
