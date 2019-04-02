/* =============================================================================
   Procedure: dbo.usp_Credit_CalcDSO
   Author:    Wade Hollister
   Created:   2019-04-02
   Purpose:   Days sales outstanding, countback method, per region and total.
              Target 42 (SAL-106 §7.1). Finance computes it differently in
              Power BI (ending AR / (TTM credit sales / 365)).
   Change log:
     2019-04-02  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_CalcDSO', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_CalcDSO
GO
CREATE PROCEDURE dbo.usp_Credit_CalcDSO
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    DECLARE @ar DECIMAL(19,2), @sales90 DECIMAL(19,2), @dso DECIMAL(9,2)
    SELECT @ar = SUM(InvoiceAmount - PaidAmount) FROM dbo.SwARInvoice WHERE Status IN ('OPEN','PASTDUE')
    SELECT @sales90 = SUM(InvoiceAmount) FROM dbo.SwARInvoice WHERE InvoiceDate > DATEADD(DAY, -90, @asOf)
    SET @dso = CASE WHEN ISNULL(@sales90, 0) > 0 THEN @ar / (@sales90 / 90.0) ELSE 0 END
    INSERT dbo.SwKPI_Snapshot (FiscalYear, FiscalWeek, StoreNumber, Channel, KPICode, KPIValue, PlanValue, CalcVersion)
    VALUES (dbo.fn_FiscalYear(@asOf), dbo.fn_FiscalWeek(@asOf), NULL, 'PRO', 'PRO_DSO', @dso, 42, 'countback90')

    SELECT sp.Region, SUM(i.InvoiceAmount - i.PaidAmount) AS OpenAR,
           SUM(CASE WHEN i.InvoiceDate > DATEADD(DAY, -90, @asOf) THEN i.InvoiceAmount ELSE 0 END) AS Sales90,
           CASE WHEN SUM(CASE WHEN i.InvoiceDate > DATEADD(DAY, -90, @asOf) THEN i.InvoiceAmount ELSE 0 END) > 0
                THEN SUM(i.InvoiceAmount - i.PaidAmount) / (SUM(CASE WHEN i.InvoiceDate > DATEADD(DAY, -90, @asOf) THEN i.InvoiceAmount ELSE 0 END) / 90.0) END AS DSO
    FROM dbo.SwARInvoice i JOIN dbo.SwProAccount pa ON pa.ProAccountID = i.ProAccountID
    LEFT JOIN dbo.SwStoreProfile sp ON sp.StoreNumber = pa.HomeStoreNumber
    WHERE i.Status IN ('OPEN','PASTDUE') OR i.InvoiceDate > DATEADD(DAY, -90, @asOf)
    GROUP BY sp.Region
    UNION ALL SELECT 'TOTAL', @ar, @sales90, @dso
END
GO
