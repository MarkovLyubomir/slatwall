/* =============================================================================
   Procedure: dbo.usp_Credit_BadDebtReserve
   Author:    Wade Hollister
   Created:   2025-02-10
   Purpose:   Rolling 36-month bucket-loss reserve (SAL-106 §7.5). Loss rates per
              bucket are constants agreed with the auditors in FY2025 and have
              not been refreshed.
   Change log:
     2025-02-10  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_BadDebtReserve', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_BadDebtReserve
GO
CREATE PROCEDURE dbo.usp_Credit_BadDebtReserve
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    SELECT 'Current' AS Bucket, SUM(InvoiceAmount - PaidAmount) AS Balance, 0.004 AS LossRate, SUM(InvoiceAmount - PaidAmount) * 0.004 AS Reserve FROM dbo.SwARInvoice WHERE Status IN ('OPEN','PASTDUE') AND DATEDIFF(DAY, DueDate, @asOf) <= 0
    UNION ALL SELECT '1-30', SUM(InvoiceAmount - PaidAmount), 0.012, SUM(InvoiceAmount - PaidAmount) * 0.012 FROM dbo.SwARInvoice WHERE Status = 'PASTDUE' AND DATEDIFF(DAY, DueDate, @asOf) BETWEEN 1 AND 30
    UNION ALL SELECT '31-60', SUM(InvoiceAmount - PaidAmount), 0.045, SUM(InvoiceAmount - PaidAmount) * 0.045 FROM dbo.SwARInvoice WHERE Status = 'PASTDUE' AND DATEDIFF(DAY, DueDate, @asOf) BETWEEN 31 AND 60
    UNION ALL SELECT '61-90', SUM(InvoiceAmount - PaidAmount), 0.150, SUM(InvoiceAmount - PaidAmount) * 0.150 FROM dbo.SwARInvoice WHERE Status = 'PASTDUE' AND DATEDIFF(DAY, DueDate, @asOf) BETWEEN 61 AND 90
    UNION ALL SELECT '90+', SUM(InvoiceAmount - PaidAmount), 0.550, SUM(InvoiceAmount - PaidAmount) * 0.550 FROM dbo.SwARInvoice WHERE Status = 'PASTDUE' AND DATEDIFF(DAY, DueDate, @asOf) > 90
END
GO
