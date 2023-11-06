/* =============================================================================
   Procedure: dbo.usp_Rpt_InventoryTurns
   Author:    Priscilla Nance
   Created:   2017-02-06
   Purpose:   Annualised inventory turns per store from the stock snapshot:
              COGS(TTM) / average inventory at cost. Target 6.2x (SUP-104).
   Change log:
     2017-02-06  PN   Initial version
     2023-11-06  WH   Average of month-end snapshots instead of two points
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_InventoryTurns', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_InventoryTurns
GO
CREATE PROCEDURE dbo.usp_Rpt_InventoryTurns
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    ;WITH cogs AS (
        SELECT sp.StoreNumber, SUM(ISNULL(im.AvgCost, 0) * oi.quantity) AS cogs
        FROM dbo.SwOrderItem oi JOIN dbo.SwOrder o ON o.orderID = oi.orderID JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
        JOIN dbo.SwSku s ON s.skuID = oi.skuID LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
        WHERE o.orderOpenDateTime > DATEADD(MONTH, -12, @asOf) AND o.orderNumber IS NOT NULL GROUP BY sp.StoreNumber),
    inv AS (
        SELECT sp.StoreNumber, AVG(x.invCost) AS avgInv
        FROM (SELECT ss.SnapshotDate, st.locationID, SUM(ss.ExtendedCost) AS invCost FROM dbo.SwStockSnapshot ss JOIN dbo.SwStock st ON st.stockID = ss.stockID
              WHERE ss.SnapshotDate > DATEADD(MONTH, -12, @asOf) AND ss.SnapshotDate = EOMONTH(ss.SnapshotDate) GROUP BY ss.SnapshotDate, st.locationID) x
        JOIN dbo.SwStoreProfile sp ON sp.locationID = x.locationID GROUP BY sp.StoreNumber)
    SELECT sp.StoreNumber, sp.StoreName, ISNULL(c.cogs, 0) AS COGS_TTM, ISNULL(i.avgInv, 0) AS AvgInventoryCost,
           CASE WHEN ISNULL(i.avgInv, 0) > 0 THEN ROUND(c.cogs / i.avgInv, 2) END AS Turns, 6.2 AS Target
    FROM dbo.SwStoreProfile sp LEFT JOIN cogs c ON c.StoreNumber = sp.StoreNumber LEFT JOIN inv i ON i.StoreNumber = sp.StoreNumber
    ORDER BY sp.StoreNumber
END
GO
