/* =============================================================================
   Procedure: dbo.usp_Inventory_Post
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Generic ledger posting (manual in/out) used by the admin "adjust"
              button and by the BisTrack financial posting feed.
   CUST-ID:   CUST-0020
   Change log:
     2014-04-22  WH   Initial version
     2017-10-30  WH   Also queue the BisTrack inventory value posting
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Inventory_Post', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Inventory_Post
GO
CREATE PROCEDURE dbo.usp_Inventory_Post
    @stockID CHAR(32),
    @quantityIn INT = 0,
    @quantityOut INT = 0,
    @reason VARCHAR(50) = 'manual',
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @skuCode VARCHAR(50), @cost DECIMAL(19,4)
    INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, createdByAccountID, stockID) VALUES (dbo.fn_NewID32(), @quantityIn, @quantityOut, GETDATE(), @byUser, @stockID)
    UPDATE dbo.SwStock SET calculatedQOH = ISNULL(calculatedQOH, 0) + @quantityIn - @quantityOut, calculatedQATS = ISNULL(calculatedQATS, 0) + @quantityIn - @quantityOut, modifiedDateTime = GETDATE() WHERE stockID = @stockID
    SELECT @skuCode = s.skuCode FROM dbo.SwStock st JOIN dbo.SwSku s ON s.skuID = st.skuID WHERE st.stockID = @stockID
    SELECT @cost = AvgCost FROM dbo.SwItemMaster_BT WHERE ItemNo = @skuCode
    INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status, ErrorText)
    VALUES ('BT_INV_POST', 'OUT', NULL, 1, 'QUEUED', @skuCode + '|' + CAST(@quantityIn - @quantityOut AS VARCHAR(10)) + '|' + CAST(ISNULL(@cost, 0) AS VARCHAR(20)) + '|' + @reason)
END
GO
