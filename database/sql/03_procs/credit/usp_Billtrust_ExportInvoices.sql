/* =============================================================================
   Procedure: dbo.usp_Billtrust_ExportInvoices
   Author:    Wade Hollister
   Created:   2025-02-10
   Purpose:   Export new invoices as a pipe-delimited file for the Billtrust SFTP
              drop (bcp via xp_cmdshell, credentials inline).
   Change log:
     2025-02-10  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Billtrust_ExportInvoices', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Billtrust_ExportInvoices
GO
CREATE PROCEDURE dbo.usp_Billtrust_ExportInvoices
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @file VARCHAR(200), @cmd VARCHAR(1000), @n INT
    SET @file = 'D:\Interfaces\Billtrust\out\INV_' + CONVERT(VARCHAR(8), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '') + '.txt'
    IF OBJECT_ID('dbo.BT_InvoiceExport_Stage') IS NOT NULL DROP TABLE dbo.BT_InvoiceExport_Stage
    SELECT i.InvoiceNo, pa.BTCustomerNo, j.JobNumber, i.InvoiceDate, i.DueDate, i.InvoiceAmount, o.orderNumber
    INTO dbo.BT_InvoiceExport_Stage
    FROM dbo.SwARInvoice i JOIN dbo.SwProAccount pa ON pa.ProAccountID = i.ProAccountID
    LEFT JOIN dbo.SwJobAccount j ON j.JobAccountID = i.JobAccountID LEFT JOIN dbo.SwOrder o ON o.orderID = i.orderID
    WHERE i.BilltrustExportedOn IS NULL AND i.Status IN ('OPEN','PASTDUE')
    SET @n = @@ROWCOUNT
    IF @n > 0
    BEGIN
        SET @cmd = 'bcp "SELECT * FROM SlatwallCommerce.dbo.BT_InvoiceExport_Stage" queryout "' + @file + '" -c -t"|" -S GSO-SQL01 -U svc_billtrust -P Sl@tw4ll2025!'
        EXEC master..xp_cmdshell @cmd, no_output
        UPDATE i SET BilltrustExportedOn = GETDATE() FROM dbo.SwARInvoice i JOIN dbo.BT_InvoiceExport_Stage s ON s.InvoiceNo = i.InvoiceNo
        INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status, FinishedOn) VALUES ('BILLTRUST_INV', 'OUT', @file, @n, 'DONE', GETDATE())
    END
    DROP TABLE dbo.BT_InvoiceExport_Stage
END
GO
