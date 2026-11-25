/* =============================================================================
   View:      dbo.vw_BT_ARAging
   Author:    Wade Hollister
   Created:   2019-04-02
   Purpose:   Aging buckets per pro account for Power BI (IF-18) and the credit
              exception Access db (IF-29, retired).
   Change log:
     2019-04-02  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_BT_ARAging', 'V') IS NOT NULL DROP VIEW dbo.vw_BT_ARAging
GO
CREATE VIEW dbo.vw_BT_ARAging AS
SELECT pa.ProAccountID, pa.BTCustomerNo, pa.CompanyName, pa.Tier, pa.HomeStoreNumber,
       SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, GETDATE()) <= 0 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Current_,
       SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, GETDATE()) BETWEEN 1 AND 30 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days1_30,
       SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, GETDATE()) BETWEEN 31 AND 60 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days31_60,
       SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, GETDATE()) BETWEEN 61 AND 90 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days61_90,
       SUM(CASE WHEN DATEDIFF(DAY, i.DueDate, GETDATE()) > 90 THEN i.InvoiceAmount - i.PaidAmount ELSE 0 END) AS Days90Plus,
       CASE WHEN EXISTS (SELECT 1 FROM dbo.SwCreditHold h WHERE h.ProAccountID = pa.ProAccountID AND h.ReleasedDate IS NULL) THEN 1 ELSE 0 END AS OnHold
FROM dbo.SwProAccount pa
LEFT JOIN dbo.SwARInvoice i ON i.ProAccountID = pa.ProAccountID AND i.Status IN ('OPEN','PASTDUE')
GROUP BY pa.ProAccountID, pa.BTCustomerNo, pa.CompanyName, pa.Tier, pa.HomeStoreNumber
GO
