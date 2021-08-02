/* =============================================================================
   Procedure: dbo.usp_EDI_Import856
   Author:    Wade Hollister
   Created:   2020-02-24
   Purpose:   Parse a raw X12 856 from SwEDIMessage into SwASN/SwASNLine.
              Segment parsing by SUBSTRING/CHARINDEX; assumes '~' segment and
              '*' element terminators (two suppliers use '\n', handled by REPLACE).
   Change log:
     2020-02-24  WH   Initial version
     2021-08-02  WH   LIN segment: item in LIN03 or LIN05 depending on supplier
   ============================================================================= */
IF OBJECT_ID('dbo.usp_EDI_Import856', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_EDI_Import856
GO
CREATE PROCEDURE dbo.usp_EDI_Import856
    @ediMessageID BIGINT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @raw VARCHAR(MAX), @partner VARCHAR(20), @seg VARCHAR(4000), @asnID INT, @line SMALLINT = 0, @vendorID CHAR(32),
            @asnNo VARCHAR(30), @po VARCHAR(20), @bol VARCHAR(30), @shipDate DATE, @carrier VARCHAR(40), @item VARCHAR(30), @qty DECIMAL(12,3), @uom VARCHAR(8)
    SELECT @raw = REPLACE(RawPayload, CHAR(10), '~'), @partner = TradingPartner FROM dbo.SwEDIMessage WHERE EDIMessageID = @ediMessageID
    SELECT TOP 1 @vendorID = vendorID FROM dbo.SwVendor WHERE accountNumber = @partner OR remoteID = @partner

    DECLARE segs CURSOR LOCAL FOR SELECT val FROM dbo.fn_SplitString(@raw, '~')
    OPEN segs
    FETCH NEXT FROM segs INTO @seg
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF LEFT(@seg, 4) = 'BSN*'
            SET @asnNo = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 3)
        IF LEFT(@seg, 4) = 'TD5*'
            SET @carrier = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 4)
        IF LEFT(@seg, 4) = 'REF*' AND SUBSTRING(@seg, 5, 2) = 'BM'
            SET @bol = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 3)
        IF LEFT(@seg, 4) = 'PRF*'
            SET @po = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 2)
        IF LEFT(@seg, 4) = 'DTM*' AND SUBSTRING(@seg, 5, 3) = '011'
            SET @shipDate = TRY_CONVERT(DATE, (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 3), 112)
        IF LEFT(@seg, 4) = 'LIN*'
        BEGIN
            IF @asnID IS NULL
            BEGIN
                INSERT dbo.SwASN (ASNNumber, vendorID, PONumber, ShipDate, ExpectedDate, Carrier, BOLNumber, DCCode, EDIRawRef)
                VALUES (@asnNo, @vendorID, @po, @shipDate, DATEADD(DAY, 3, @shipDate), @carrier, @bol, 'KNV', CAST(@ediMessageID AS VARCHAR(20)))
                SET @asnID = SCOPE_IDENTITY()
            END
            SET @item = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = CASE WHEN @partner IN ('BLDRFS','WEYER') THEN 6 ELSE 4 END)
            SET @line = @line + 1
            INSERT dbo.SwASNLine (ASNID, LineNo, ItemNo) VALUES (@asnID, @line, @item)
        END
        IF LEFT(@seg, 4) = 'SN1*' AND @asnID IS NOT NULL
        BEGIN
            SET @qty = TRY_CAST((SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 3) AS DECIMAL(12,3))
            SET @uom = (SELECT val FROM dbo.fn_SplitString(@seg, '*') WHERE pos = 4)
            UPDATE dbo.SwASNLine SET ShippedQty = @qty, UOM = @uom WHERE ASNID = @asnID AND LineNo = @line
        END
        FETCH NEXT FROM segs INTO @seg
    END
    CLOSE segs DEALLOCATE segs
    UPDATE dbo.SwASN SET LineCount = @line WHERE ASNID = @asnID
    UPDATE dbo.SwEDIMessage SET Status = CASE WHEN @asnID IS NULL THEN 'ERROR' ELSE 'DONE' END, ProcessedOn = GETDATE(), RelatedRef = CAST(@asnID AS VARCHAR(20)) WHERE EDIMessageID = @ediMessageID
    IF @asnID IS NOT NULL EXEC dbo.usp_ASN_Match @asnID = @asnID
END
GO
