/* =============================================================================
   Procedure: dbo.usp_Rpt_CompSales_Finance
   Author:    Wade Hollister
   Created:   2021-08-16
   Purpose:   Finance's comp (definition #3): invoiced sales (SwARInvoice) for
              pro plus closed orders for retail, calendar month not fiscal week,
              channel = origin not location. FP&A reconciles the three every
              Monday in a spreadsheet (definition #4).
   Change log:
     2021-08-16  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_CompSales_Finance', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_CompSales_Finance
GO
CREATE PROCEDURE dbo.usp_Rpt_CompSales_Finance
    @year INT,
    @month INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from DATE = DATEFROMPARTS(@year, @month, 1), @to DATE = EOMONTH(DATEFROMPARTS(@year, @month, 1))
    SELECT oo.orderOriginType AS Channel,
           SUM(CASE WHEN YEAR(x.d) = @year THEN x.amt ELSE 0 END) AS ThisYear,
           SUM(CASE WHEN YEAR(x.d) = @year - 1 THEN x.amt ELSE 0 END) AS LastYear
    FROM (
        SELECT i.orderID, i.InvoiceDate AS d, i.InvoiceAmount AS amt FROM dbo.SwARInvoice i WHERE i.InvoiceDate BETWEEN DATEADD(YEAR, -1, @from) AND @to AND i.Status <> 'VOID'
        UNION ALL
        SELECT o.orderID, CAST(o.orderCloseDateTime AS DATE), o.calculatedTotal FROM dbo.SwOrder o
        WHERE o.orderCloseDateTime BETWEEN DATEADD(YEAR, -1, @from) AND @to AND o.orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostClosed')
          AND NOT EXISTS (SELECT 1 FROM dbo.SwARInvoice i WHERE i.orderID = o.orderID)
    ) x
    JOIN dbo.SwOrder o ON o.orderID = x.orderID LEFT JOIN dbo.SwOrderOrigin oo ON oo.orderOriginID = o.orderOriginID
    WHERE MONTH(x.d) = @month
    GROUP BY oo.orderOriginType
END
GO
