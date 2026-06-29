/* =============================================================================
   Procedure: dbo.usp_Physical_Commit
   Author:    Wade Hollister
   Created:   2014-10-06
   Purpose:   Commit a physical: for every counted stock row, post the variance
              to the ledger via an adjustment, write SwShrinkEvent rows, and
              close the physical. Holds a TABLOCKX on SwStock for the duration
              "so nobody sells while we count".
   CUST-ID:   CUST-0024
   Change log:
     2014-10-06  WH   Initial version
     2021-01-18  WH   Shrink events + cost value for the shrink report
     2026-06-29  WH   AUD-210 remediation: variance > $500 requires @approvedBy
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Physical_Commit', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Physical_Commit
GO
CREATE PROCEDURE dbo.usp_Physical_Commit
    @physicalID CHAR(32),
    @byUser VARCHAR(50) = NULL,
    @approvedBy VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32), @counted INT, @qoh INT, @var INT, @saID CHAR(32), @locationID CHAR(32), @skuID CHAR(32), @cost DECIMAL(19,4), @store TINYINT, @pcID CHAR(32), @bigVariance DECIMAL(19,2),
            @fromLoc CHAR(32), @toLoc CHAR(32), @adjType VARCHAR(50), @absVar INT

    BEGIN TRAN
    SELECT TOP 1 @stockID = stockID FROM dbo.SwStock WITH (TABLOCKX, HOLDLOCK)   -- lock everything

    SELECT @bigVariance = SUM(ABS(pci.quantity - ISNULL(st.calculatedQOH, 0)) * ISNULL(im.AvgCost, 0))
    FROM dbo.SwPhysicalCount pc JOIN dbo.SwPhysicalCountItem pci ON pci.physicalCountID = pc.physicalCountID
    JOIN dbo.SwStock st ON st.stockID = pci.stockID JOIN dbo.SwSku s ON s.skuID = st.skuID LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
    WHERE pc.physicalID = @physicalID
    IF @bigVariance > 500 AND @approvedBy IS NULL
    BEGIN
        ROLLBACK
        RAISERROR('Physical variance exceeds $500 at cost; store manager approval required', 16, 1)
        RETURN
    END

    DECLARE c CURSOR LOCAL FOR
        SELECT pci.stockID, pci.quantity, pc.locationID, st.skuID, pc.physicalCountID
        FROM dbo.SwPhysicalCount pc JOIN dbo.SwPhysicalCountItem pci ON pci.physicalCountID = pc.physicalCountID JOIN dbo.SwStock st ON st.stockID = pci.stockID
        WHERE pc.physicalID = @physicalID AND pci.stockID IS NOT NULL
    OPEN c
    FETCH NEXT FROM c INTO @stockID, @counted, @locationID, @skuID, @pcID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @qoh = dbo.fn_Stock_QOH(@stockID)
        SET @var = @counted - @qoh
        IF @var <> 0
        BEGIN
            SET @fromLoc = CASE WHEN @var < 0 THEN @locationID END
            SET @toLoc = CASE WHEN @var > 0 THEN @locationID END
            SET @adjType = CASE WHEN @var < 0 THEN 'satManualOut' ELSE 'satManualIn' END
            SET @absVar = ABS(@var)
            EXEC dbo.usp_StockAdjustment_Create @fromLocationID = @fromLoc, @toLocationID = @toLoc, @adjustmentType = @adjType, @physicalID = @physicalID, @stockAdjustmentID = @saID OUTPUT
            EXEC dbo.usp_StockAdjustment_AddItems @stockAdjustmentID = @saID, @skuID = @skuID, @quantity = @absVar
            EXEC dbo.usp_StockAdjustment_Process @stockAdjustmentID = @saID, @byUser = @byUser
            IF @var < 0
            BEGIN
                SELECT @store = StoreNumber FROM dbo.SwStoreProfile WHERE locationID = @locationID
                SELECT @cost = im.AvgCost FROM dbo.SwSku s LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode WHERE s.skuID = @skuID
                INSERT dbo.SwShrinkEvent (StoreNumber, skuID, EventDate, ShrinkType, Qty, CostValue, SourceRef, physicalCountID, OverrideUser)
                VALUES (ISNULL(@store, 0), @skuID, CAST(GETDATE() AS DATE), 'COUNT', ABS(@var), ABS(@var) * ISNULL(@cost, 0), @physicalID, @pcID, @approvedBy)
            END
        END
        UPDATE dbo.SwPhysicalCountItem SET countPostDateTime = GETDATE() WHERE physicalCountID = @pcID AND stockID = @stockID
        FETCH NEXT FROM c INTO @stockID, @counted, @locationID, @skuID, @pcID
    END
    CLOSE c DEALLOCATE c
    UPDATE dbo.SwPhysicalCount SET countPostDateTime = GETDATE() WHERE physicalID = @physicalID
    UPDATE dbo.SwPhysical SET physicalStatusTypeID = dbo.fn_GetTypeID('physicalStatusType','pstClosed'), modifiedDateTime = GETDATE() WHERE physicalID = @physicalID
    UPDATE dbo.SwCycleCountSchedule SET LastCountedOn = CAST(GETDATE() AS DATE), NextDueOn = DATEADD(DAY, FrequencyDays, CAST(GETDATE() AS DATE))
    WHERE skuID IN (SELECT st.skuID FROM dbo.SwPhysicalCount pc JOIN dbo.SwPhysicalCountItem pci ON pci.physicalCountID = pc.physicalCountID JOIN dbo.SwStock st ON st.stockID = pci.stockID WHERE pc.physicalID = @physicalID)
    COMMIT
END
GO
