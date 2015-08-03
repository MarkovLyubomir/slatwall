/* =============================================================================
   Procedure: dbo.usp_StockAdjustment_Process
   Author:    Wade Hollister
   Created:   2014-10-06
   Purpose:   Process an adjustment: creates the delivery (out of from-stock) and
              receiver (into to-stock) and the ledger rows for both legs, then
              closes it. Transfers are instantaneous - no in-transit state.
   Change log:
     2014-10-06  WH   Initial version
     2015-08-03  WH   Manual in/out types (one leg only)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_StockAdjustment_Process', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_StockAdjustment_Process
GO
CREATE PROCEDURE dbo.usp_StockAdjustment_Process
    @stockAdjustmentID CHAR(32),
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @type VARCHAR(50), @deliveryID CHAR(32), @receiverID CHAR(32), @itemID CHAR(32), @qty INT, @fromStock CHAR(32), @toStock CHAR(32), @sadiID CHAR(32), @sriID CHAR(32)
    SELECT @type = t.systemCode FROM dbo.SwStockAdjustment sa JOIN dbo.SwType t ON t.typeID = sa.stockAdjustmentTypeID WHERE sa.stockAdjustmentID = @stockAdjustmentID

    BEGIN TRAN
    UPDATE dbo.SwStockAdjustment SET stockAdjustmentStatusTypeID = dbo.fn_GetTypeID('stockAdjustmentStatusType','sastProcessing') WHERE stockAdjustmentID = @stockAdjustmentID
    IF @type IN ('satLocationTransfer','satManualOut')
    BEGIN
        SET @deliveryID = dbo.fn_NewID32()
        INSERT dbo.SwStockAdjustmentDelivery (stockAdjustmentDeliveryID, deliveryOpenDateTime, stockAdjustmentID, createdDateTime, createdByAccountID) VALUES (@deliveryID, GETDATE(), @stockAdjustmentID, GETDATE(), @byUser)
    END
    IF @type IN ('satLocationTransfer','satManualIn')
    BEGIN
        SET @receiverID = dbo.fn_NewID32()
        INSERT dbo.SwStockReceiver (stockReceiverID, receiverType, stockAdjustmentID, createdDateTime, createdByAccountID) VALUES (@receiverID, 'stockAdjustment', @stockAdjustmentID, GETDATE(), @byUser)
    END

    DECLARE c CURSOR LOCAL FOR SELECT stockAdjustmentItemID, quantity, fromStockID, toStockID FROM dbo.SwStockAdjustmentItem WHERE stockAdjustmentID = @stockAdjustmentID
    OPEN c
    FETCH NEXT FROM c INTO @itemID, @qty, @fromStock, @toStock
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @deliveryID IS NOT NULL AND @fromStock IS NOT NULL
        BEGIN
            SET @sadiID = dbo.fn_NewID32()
            INSERT dbo.SwStockAdjustmentDeliveryItem (stockAdjustmentDeliveryItemID, quantity, stockAdjustmentDeliveryID, stockAdjustmentItemID, stockID, createdDateTime) VALUES (@sadiID, @qty, @deliveryID, @itemID, @fromStock, GETDATE())
            INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, stockAdjustmentDeliveryItemID) VALUES (dbo.fn_NewID32(), 0, @qty, GETDATE(), @fromStock, @sadiID)
        END
        IF @receiverID IS NOT NULL AND @toStock IS NOT NULL
        BEGIN
            SET @sriID = dbo.fn_NewID32()
            INSERT dbo.SwStockReceiverItem (stockReceiverItemID, quantity, currencyCode, createdDateTime, stockID, stockReceiverID, stockAdjustmentItemID) VALUES (@sriID, @qty, 'USD', GETDATE(), @toStock, @receiverID, @itemID)
            INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, stockReceiverItemID) VALUES (dbo.fn_NewID32(), @qty, 0, GETDATE(), @toStock, @sriID)
        END
        FETCH NEXT FROM c INTO @itemID, @qty, @fromStock, @toStock
    END
    CLOSE c DEALLOCATE c
    IF @deliveryID IS NOT NULL UPDATE dbo.SwStockAdjustmentDelivery SET deliveryCloseDateTime = GETDATE() WHERE stockAdjustmentDeliveryID = @deliveryID
    UPDATE dbo.SwStockAdjustment SET stockAdjustmentStatusTypeID = dbo.fn_GetTypeID('stockAdjustmentStatusType','sastClosed'), modifiedDateTime = GETDATE() WHERE stockAdjustmentID = @stockAdjustmentID
    UPDATE dbo.SwPickTask SET PickStatus = 'NEW' WHERE PickStatus = 'AWAITING_XFER'   -- wakes up ALL waiting picks, not just this one
    COMMIT
END
GO
