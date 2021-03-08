/* =============================================================================
   Procedure: dbo.usp_Web_SyncInventory
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Build the Adobe Commerce inventory feed from the CACHED stock
              numbers (availability calculation #2). Runs at 06:00 after the
              batch; when the batch overruns, the web sells yesterday's stock.
   Change log:
     2018-11-26  PN   Initial version
     2021-03-08  PN   Per-store sources (MSI)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Web_SyncInventory', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Web_SyncInventory
GO
CREATE PROCEDURE dbo.usp_Web_SyncInventory
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @n INT
    -- de-duplicate the queue: keep the latest row per sku/store
    ;WITH q AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY skuID, StoreNumber ORDER BY QueuedOn DESC) AS rn FROM dbo.SwWebSync_Inventory WHERE Status = 'PENDING')
    UPDATE q SET Status = 'SUPERSEDED' WHERE rn > 1

    -- anything not queued tonight gets the cached value
    INSERT dbo.SwWebSync_Inventory (skuID, StoreNumber, WebQty)
    SELECT st.skuID, sp.StoreNumber, CASE WHEN ISNULL(st.calculatedQATS, 0) < 0 THEN 0 ELSE ISNULL(st.calculatedQATS, 0) END
    FROM dbo.SwStock st JOIN dbo.SwStoreProfile sp ON sp.locationID = st.locationID JOIN dbo.SwSku s ON s.skuID = st.skuID
    WHERE s.publishedFlag = 1 AND NOT EXISTS (SELECT 1 FROM dbo.SwWebSync_Inventory w WHERE w.skuID = st.skuID AND w.StoreNumber = sp.StoreNumber AND w.Status = 'PENDING')
    SET @n = @@ROWCOUNT
    INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status) VALUES ('ADOBE_INV', 'OUT', 'inv_' + CONVERT(VARCHAR(8), GETDATE(), 112) + '.csv', @n, 'QUEUED')
END
GO
