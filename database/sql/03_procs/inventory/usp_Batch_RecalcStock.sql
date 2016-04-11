/* =============================================================================
   Procedure: dbo.usp_Batch_RecalcStock
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   THE nightly stock recalc. Walks every SwStock row, recomputes
              calculatedQOH/QATS/QNC from the ledger, writes the snapshot, and
              queues the web inventory sync. ~310k stock rows. This is the step
              the 4h40m batch window is made of.
   CUST-ID:   CUST-0021
   Change log:
     2014-04-22  WH   Initial version
     2016-04-11  WH   Snapshot table
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Batch_RecalcStock', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Batch_RecalcStock
GO
CREATE PROCEDURE dbo.usp_Batch_RecalcStock
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32), @skuID CHAR(32), @locationID CHAR(32), @qoh INT, @qats INT, @qnc INT, @n INT = 0, @start DATETIME = GETDATE(), @store TINYINT, @onOrder INT, @cost DECIMAL(19,4), @skuCode VARCHAR(50)
    DECLARE @today DATE = CAST(GETDATE() AS DATE)

    BEGIN TRAN
    DECLARE c CURSOR LOCAL FAST_FORWARD FOR
        SELECT st.stockID, st.skuID, st.locationID, s.skuCode FROM dbo.SwStock st JOIN dbo.SwSku s ON s.skuID = st.skuID WHERE s.activeFlag = 1
    OPEN c
    FETCH NEXT FROM c INTO @stockID, @skuID, @locationID, @skuCode
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @qoh = dbo.fn_Stock_QOH(@stockID)
        SET @qats = dbo.fn_Stock_QATS(@stockID)
        SELECT @qnc = ISNULL(calculatedQNC, 0) FROM dbo.SwStock WHERE stockID = @stockID
        SELECT @onOrder = ISNULL(SUM(voi.quantity), 0) FROM dbo.SwVendorOrderItem voi JOIN dbo.SwVendorOrder vo ON vo.vendorOrderID = voi.vendorOrderID
        WHERE voi.stockID = @stockID AND vo.vendorOrderStatusTypeID = dbo.fn_GetTypeID('vendorOrderStatusType','vostOpen')
        SELECT @cost = AvgCost FROM dbo.SwItemMaster_BT WHERE ItemNo = @skuCode

        UPDATE dbo.SwStock SET calculatedQOH = @qoh, calculatedQATS = @qats - @qnc, modifiedDateTime = GETDATE(), modifiedByAccountID = 'nightly' WHERE stockID = @stockID
        INSERT dbo.SwStockSnapshot (SnapshotDate, stockID, QOH, QATS, QNC, OnOrder, AvgCost, ExtendedCost) VALUES (@today, @stockID, @qoh, @qats - @qnc, @qnc, @onOrder, @cost, @qoh * ISNULL(@cost, 0))

        SELECT @store = StoreNumber FROM dbo.SwStoreProfile WHERE locationID = @locationID
        INSERT dbo.SwWebSync_Inventory (skuID, StoreNumber, WebQty) VALUES (@skuID, @store, CASE WHEN @qats - @qnc < 0 THEN 0 ELSE @qats - @qnc END)

        SET @n = @n + 1
        IF @n % 500 = 0
        BEGIN
            COMMIT TRAN
            BEGIN TRAN
        END
        FETCH NEXT FROM c INTO @stockID, @skuID, @locationID, @skuCode
    END
    CLOSE c DEALLOCATE c
    COMMIT TRAN

    -- roll up to sku and product
    UPDATE s SET s.calculatedQATS = x.q FROM dbo.SwSku s JOIN (SELECT skuID, SUM(calculatedQATS) AS q FROM dbo.SwStock GROUP BY skuID) x ON x.skuID = s.skuID
    UPDATE p SET p.calculatedQATS = x.q FROM dbo.SwProduct p JOIN (SELECT productID, SUM(calculatedQATS) AS q FROM dbo.SwSku GROUP BY productID) x ON x.productID = p.productID

    INSERT dbo.SwETL_Log (JobName, StepName, StartedOn, FinishedOn, RowsAffected, Status) VALUES ('usp_Batch_RecalcStock', 'recalc', @start, GETDATE(), @n, 'OK')
END
GO
