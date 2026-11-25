/* =============================================================================
   Procedure: dbo.usp_CycleCount_Schedule
   Author:    Wade Hollister
   Created:   2021-01-18
   Purpose:   (Re)build the cycle-count schedule: ABC by TTM sales value per
              location (A top 20% of value = 30 days, B next 30% = 90 days,
              C = 180 days), per SUP-104 §6.
   Change log:
     2021-01-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_CycleCount_Schedule', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_CycleCount_Schedule
GO
CREATE PROCEDURE dbo.usp_CycleCount_Schedule
    @locationID CHAR(32) = NULL
AS
BEGIN
    SET NOCOUNT ON
    ;WITH sales AS (
        SELECT o.locationID, oi.skuID, SUM(oi.price * oi.quantity) AS val
        FROM dbo.SwOrderItem oi JOIN dbo.SwOrder o ON o.orderID = oi.orderID
        WHERE o.orderCloseDateTime > DATEADD(MONTH, -12, GETDATE()) AND (@locationID IS NULL OR o.locationID = @locationID)
        GROUP BY o.locationID, oi.skuID),
    ranked AS (
        SELECT locationID, skuID, val, SUM(val) OVER (PARTITION BY locationID ORDER BY val DESC ROWS UNBOUNDED PRECEDING) / NULLIF(SUM(val) OVER (PARTITION BY locationID), 0) AS cum
        FROM sales)
    MERGE dbo.SwCycleCountSchedule AS tgt
    USING (SELECT locationID, skuID, CASE WHEN cum <= 0.20 THEN 'A' WHEN cum <= 0.50 THEN 'B' ELSE 'C' END AS abc FROM ranked) AS src
        ON tgt.locationID = src.locationID AND tgt.skuID = src.skuID
    WHEN MATCHED THEN UPDATE SET ABCClass = src.abc, FrequencyDays = CASE src.abc WHEN 'A' THEN 30 WHEN 'B' THEN 90 ELSE 180 END
    WHEN NOT MATCHED THEN INSERT (locationID, skuID, ABCClass, FrequencyDays, NextDueOn) VALUES (src.locationID, src.skuID, src.abc, CASE src.abc WHEN 'A' THEN 30 WHEN 'B' THEN 90 ELSE 180 END, CAST(GETDATE() AS DATE));
END
GO
