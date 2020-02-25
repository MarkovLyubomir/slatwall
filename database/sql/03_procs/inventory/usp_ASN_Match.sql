/* =============================================================================
   Procedure: dbo.usp_ASN_Match
   Author:    Wade Hollister
   Created:   2020-02-24
   Purpose:   Match an EDI 856 ASN to its PO by PO number, then by vendor + expected
              date +/- 3 days. Creates the receiver shell so the dock can receive
              against the ASN (OPS-203 §2).
   Change log:
     2020-02-24  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_ASN_Match', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ASN_Match
GO
CREATE PROCEDURE dbo.usp_ASN_Match
    @asnID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @po VARCHAR(20), @vendorID CHAR(32), @expected DATE, @voID CHAR(32), @receiverID CHAR(32), @bol VARCHAR(30)
    SELECT @po = PONumber, @vendorID = vendorID, @expected = ExpectedDate, @bol = BOLNumber FROM dbo.SwASN WHERE ASNID = @asnID
    SELECT @voID = vendorOrderID FROM dbo.SwVendorOrder WHERE vendorOrderNumber = @po
    IF @voID IS NULL
        SELECT TOP 1 @voID = vendorOrderID FROM dbo.SwVendorOrder WHERE vendorID = @vendorID AND ABS(DATEDIFF(DAY, estimatedReceivalDateTime, @expected)) <= 3
          AND vendorOrderStatusTypeID = dbo.fn_GetTypeID('vendorOrderStatusType','vostOpen') ORDER BY estimatedReceivalDateTime
    IF @voID IS NULL
    BEGIN
        UPDATE dbo.SwASN SET MatchStatus = 'UNMATCHED' WHERE ASNID = @asnID
        RETURN
    END
    UPDATE dbo.SwASN SET vendorOrderID = @voID, MatchStatus = 'MATCHED' WHERE ASNID = @asnID
    -- resolve sku on lines by item no / alternate code
    UPDATE l SET l.skuID = s.skuID FROM dbo.SwASNLine l JOIN dbo.SwSku s ON s.skuCode = l.ItemNo WHERE l.ASNID = @asnID AND l.skuID IS NULL
    UPDATE l SET l.skuID = a.skuID FROM dbo.SwASNLine l JOIN dbo.SwAlternateSkuCode a ON a.alternateSkuCode = l.ItemNo WHERE l.ASNID = @asnID AND l.skuID IS NULL
    SET @receiverID = dbo.fn_NewID32()
    INSERT dbo.SwStockReceiver (stockReceiverID, packingSlipNumber, boxCount, receiverType, vendorOrderID, createdDateTime) SELECT @receiverID, @bol, LineCount, 'vendorOrder', @voID, GETDATE() FROM dbo.SwASN WHERE ASNID = @asnID
END
GO
