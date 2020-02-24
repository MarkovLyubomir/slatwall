/* =============================================================================
   Procedure: dbo.usp_EDI_Export850
   Author:    Wade Hollister
   Created:   2020-02-24
   Purpose:   Build an X12 850 for a PO and drop it in SwEDIMessage for the VAN
              pickup job. ISA/GS control numbers from SwSetting.
   Change log:
     2020-02-24  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_EDI_Export850', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_EDI_Export850
GO
CREATE PROCEDURE dbo.usp_EDI_Export850
    @vendorOrderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @po VARCHAR(20), @partner VARCHAR(20), @ctrl INT, @x VARCHAR(MAX), @n INT, @date VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
    SELECT @po = vo.vendorOrderNumber, @partner = v.accountNumber FROM dbo.SwVendorOrder vo JOIN dbo.SwVendor v ON v.vendorID = vo.vendorID WHERE vo.vendorOrderID = @vendorOrderID
    UPDATE dbo.SwSetting SET settingValue = CAST(CAST(settingValue AS INT) + 1 AS VARCHAR(20)), @ctrl = CAST(settingValue AS INT) + 1 WHERE settingName = 'ediControlSeq'
    SET @ctrl = ISNULL(@ctrl, 1)
    SET @x = 'ISA*00*          *00*          *ZZ*SLATWALL       *ZZ*' + LEFT(@partner + REPLICATE(' ', 15), 15) + '*' + RIGHT(@date, 6) + '*' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 108), ':', '') + '*U*00401*' + RIGHT('000000000' + CAST(@ctrl AS VARCHAR(9)), 9) + '*0*P*>~'
         + 'GS*PO*SLATWALL*' + @partner + '*' + @date + '*' + REPLACE(CONVERT(VARCHAR(5), GETDATE(), 108), ':', '') + '*' + CAST(@ctrl AS VARCHAR(9)) + '*X*004010~'
         + 'ST*850*0001~BEG*00*SA*' + @po + '**' + @date + '~'
    SELECT @x = @x + 'PO1*' + CAST(ROW_NUMBER() OVER (ORDER BY voi.createdDateTime) AS VARCHAR(5)) + '*' + CAST(voi.quantity AS VARCHAR(10)) + '*EA*' + CAST(voi.cost AS VARCHAR(20)) + '**VN*' + s.skuCode + '~'
    FROM dbo.SwVendorOrderItem voi JOIN dbo.SwStock st ON st.stockID = voi.stockID JOIN dbo.SwSku s ON s.skuID = st.skuID WHERE voi.vendorOrderID = @vendorOrderID
    SELECT @n = COUNT(*) FROM dbo.SwVendorOrderItem WHERE vendorOrderID = @vendorOrderID
    SET @x = @x + 'CTT*' + CAST(@n AS VARCHAR(5)) + '~SE*' + CAST(@n + 3 AS VARCHAR(5)) + '*0001~GE*1*' + CAST(@ctrl AS VARCHAR(9)) + '~IEA*1*' + RIGHT('000000000' + CAST(@ctrl AS VARCHAR(9)), 9) + '~'
    INSERT dbo.SwEDIMessage (Direction, TransactionSet, TradingPartner, ControlNumber, RawPayload, Status, RelatedRef) VALUES ('OUT', '850', @partner, CAST(@ctrl AS VARCHAR(20)), @x, 'NEW', @po)
END
GO
