/* =============================================================================
   Procedure: dbo.usp_Credit_AgeReceivables
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Nightly aging: flag PASTDUE invoices, compute buckets per account
              into a temp table and return them (used by the dunning run and the
              AR report).
   Change log:
     2016-06-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_AgeReceivables', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_AgeReceivables
GO
CREATE PROCEDURE dbo.usp_Credit_AgeReceivables
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    UPDATE dbo.SwARInvoice SET Status = 'PASTDUE', UpdatedOn = GETDATE() WHERE Status = 'OPEN' AND DueDate < @asOf AND InvoiceAmount - PaidAmount > 0
    UPDATE dbo.SwARInvoice SET Status = 'PAID', UpdatedOn = GETDATE() WHERE Status IN ('OPEN','PASTDUE') AND PaidAmount >= InvoiceAmount

    SELECT i.ProAccountID, pa.BTCustomerNo, pa.CompanyName, pa.Tier,
           SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, @asOf) <= 0 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Current_,
           SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, @asOf) BETWEEN 1 AND 30 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days1_30,
           SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, @asOf) BETWEEN 31 AND 60 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days31_60,
           SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, @asOf) BETWEEN 61 AND 90 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days61_90,
           SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, @asOf) > 90 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days90Plus,
           MAX(DATEDIFF(DAY, i.DueDate, @asOf)) AS OldestDays
    INTO #aging
    FROM dbo.SwARInvoice i JOIN dbo.SwProAccount pa ON pa.ProAccountID = i.ProAccountID
    WHERE i.Status IN ('OPEN','PASTDUE')
    GROUP BY i.ProAccountID, pa.BTCustomerNo, pa.CompanyName, pa.Tier

    SELECT * FROM #aging ORDER BY Days90Plus DESC, Days61_90 DESC
    DROP TABLE #aging
END
GO
