/* =============================================================================
   Procedure: dbo.usp_EDI_Import855
   Author:    Wade Hollister
   Created:   2020-02-24
   Purpose:   PO acknowledgement (855): mark PO acknowledged / update expected date.
   Change log:
     2020-02-24  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_EDI_Import855', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_EDI_Import855
GO
CREATE PROCEDURE dbo.usp_EDI_Import855
    @ediMessageID BIGINT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @raw VARCHAR(MAX), @po VARCHAR(20), @ack CHAR(2), @date DATE, @p INT
    SELECT @raw = REPLACE(RawPayload, CHAR(10), '~') FROM dbo.SwEDIMessage WHERE EDIMessageID = @ediMessageID
    SET @p = CHARINDEX('BAK*', @raw)
    IF @p > 0
    BEGIN
        SET @ack = SUBSTRING(@raw, @p + 7, 2)
        SET @po = SUBSTRING(@raw, @p + 10, CHARINDEX('*', @raw + '*', @p + 10) - (@p + 10))
    END
    SET @p = CHARINDEX('DTM*067*', @raw)
    IF @p > 0 SET @date = TRY_CONVERT(DATE, SUBSTRING(@raw, @p + 8, 8), 112)
    UPDATE dbo.SwVendorOrder SET estimatedReceivalDateTime = ISNULL(@date, estimatedReceivalDateTime), remoteID = 'ACK:' + ISNULL(@ack, '??'), modifiedDateTime = GETDATE() WHERE vendorOrderNumber = @po
    UPDATE dbo.SwEDIMessage SET Status = CASE WHEN @@ROWCOUNT = 0 THEN 'ERROR' ELSE 'DONE' END, ProcessedOn = GETDATE(), RelatedRef = @po WHERE EDIMessageID = @ediMessageID
END
GO
