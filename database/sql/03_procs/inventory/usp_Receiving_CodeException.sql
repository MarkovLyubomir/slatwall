/* =============================================================================
   Procedure: dbo.usp_Receiving_CodeException
   Author:    Wade Hollister
   Created:   2020-02-24
   Purpose:   Dock codes an over/short/damaged line (OPS-203 §3 codes OVR, SHT,
              DMG, SUB, NOPO). Damaged qty goes to QNC on the cache only.
   Change log:
     2020-02-24  WH   Initial version
     2022-08-15  WH   Chargeback trigger: SHT > 2% or DMG > 1% of line (LEG-110 §7)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Receiving_CodeException', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Receiving_CodeException
GO
CREATE PROCEDURE dbo.usp_Receiving_CodeException
    @stockReceiverItemID CHAR(32),
    @exceptionCode CHAR(3),
    @expectedQty DECIMAL(12,3),
    @receivedQty DECIMAL(12,3),
    @damagedQty DECIMAL(12,3) = 0,
    @reasonText VARCHAR(200) = NULL,
    @raisedBy VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @id INT, @chargeback BIT = 0, @stockID CHAR(32)
    INSERT dbo.SwReceivingException (stockReceiverItemID, ExceptionCode, ExpectedQty, ReceivedQty, DamagedQty, ReasonText, RaisedBy)
    VALUES (@stockReceiverItemID, @exceptionCode, @expectedQty, @receivedQty, @damagedQty, @reasonText, @raisedBy)
    SET @id = SCOPE_IDENTITY()
    IF (@exceptionCode = 'SHT' AND @expectedQty > 0 AND (@expectedQty - @receivedQty) / @expectedQty > 0.02)
       OR (@exceptionCode = 'DMG' AND @expectedQty > 0 AND @damagedQty / @expectedQty > 0.01)
        EXEC dbo.usp_Receiving_RaiseChargeback @receivingExceptionID = @id
    IF @damagedQty > 0
    BEGIN
        SELECT @stockID = stockID FROM dbo.SwStockReceiverItem WHERE stockReceiverItemID = @stockReceiverItemID
        UPDATE dbo.SwStock SET calculatedQNC = ISNULL(calculatedQNC, 0) + CAST(@damagedQty AS INT), calculatedQATS = ISNULL(calculatedQATS, 0) - CAST(@damagedQty AS INT) WHERE stockID = @stockID
    END
END
GO
