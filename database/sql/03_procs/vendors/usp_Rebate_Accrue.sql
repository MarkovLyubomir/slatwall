/* =============================================================================
   Procedure: dbo.usp_Rebate_Accrue
   Author:    Wade Hollister
   Created:   2015-11-02
   Purpose:   Monthly vendor rebate accrual. Reads the rebate programs from the
              Access tracker over the linked server [ACCESS_REBATES] (the table
              was copied into this database in 2023 but the proc still hits
              the linked server first and falls back).
   Change log:
     2015-11-02  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rebate_Accrue', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rebate_Accrue
GO
CREATE PROCEDURE dbo.usp_Rebate_Accrue
    @periodYYYYMM CHAR(6)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @rebateID INT, @vendorNo VARCHAR(20), @type VARCHAR(20), @year SMALLINT, @basis MONEY, @pct FLOAT, @accrual MONEY, @from DATE, @to DATE
    SET @from = DATEFROMPARTS(CAST(LEFT(@periodYYYYMM, 4) AS INT), CAST(RIGHT(@periodYYYYMM, 2) AS INT), 1)
    SET @to = EOMONTH(@from)

    CREATE TABLE #programs (RebateID INT, VendorNo VARCHAR(20), ProgramYear SMALLINT, RebateType VARCHAR(20))
    BEGIN TRY
        INSERT #programs SELECT RebateID, VendorNo, ProgramYear, RebateType FROM [ACCESS_REBATES]...[tblVendorRebate] WHERE ProgramYear = YEAR(@from)
    END TRY
    BEGIN CATCH
        INSERT #programs SELECT RebateID, VendorNo, ProgramYear, RebateType FROM dbo.tblVendorRebate WHERE ProgramYear = YEAR(@from)
    END CATCH

    DECLARE c CURSOR LOCAL FOR SELECT RebateID, VendorNo, ProgramYear, RebateType FROM #programs
    OPEN c
    FETCH NEXT FROM c INTO @rebateID, @vendorNo, @year, @type
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- purchases at cost received in the period for this vendor
        SELECT @basis = ISNULL(SUM(sri.quantity * sri.cost), 0)
        FROM dbo.SwStockReceiverItem sri JOIN dbo.SwStockReceiver sr ON sr.stockReceiverID = sri.stockReceiverID
        JOIN dbo.SwVendorOrder vo ON vo.vendorOrderID = sr.vendorOrderID JOIN dbo.SwVendor v ON v.vendorID = vo.vendorID
        WHERE v.accountNumber = @vendorNo AND sri.createdDateTime BETWEEN @from AND @to
        EXEC dbo.usp_Rebate_TierLookup @rebateID = @rebateID, @ytdBasis = @basis, @pct = @pct OUTPUT
        SET @accrual = ROUND(@basis * ISNULL(@pct, 0) / 100.0, 2)
        UPDATE dbo.tblVendorRebate SET BasisAmt = ISNULL(BasisAmt, 0) + @basis, AccruedAmt = ISNULL(AccruedAmt, 0) + @accrual, LastAccrualDate = GETDATE() WHERE RebateID = @rebateID
        INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, RecordCount, Status, ErrorText) VALUES ('BT_GL_REBATE', 'OUT', 1, 'QUEUED', @vendorNo + '|' + @periodYYYYMM + '|' + CAST(@accrual AS VARCHAR(20)))
        FETCH NEXT FROM c INTO @rebateID, @vendorNo, @year, @type
    END
    CLOSE c DEALLOCATE c
    DROP TABLE #programs
END
GO
