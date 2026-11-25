/* =============================================================================
   Procedure: dbo.usp_Rpt_OnTimeDelivery
   Author:    Priscilla Nance
   Created:   2022-03-01
   Purpose:   On-time delivery % by region from SwDeliveryStop.OnTimeFlag. Target
              94% (LOG-111). Stops without a window count as on time.
   Change log:
     2022-03-01  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_OnTimeDelivery', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_OnTimeDelivery
GO
CREATE PROCEDURE dbo.usp_Rpt_OnTimeDelivery
    @from DATE,
    @to DATE
AS
BEGIN
    SET NOCOUNT ON
    SELECT ISNULL(sp.Region, 'DC') AS Region, COUNT(*) AS Stops, SUM(CASE WHEN ds.OnTimeFlag = 1 THEN 1 ELSE 0 END) AS OnTime,
           ROUND(100.0 * SUM(CASE WHEN ds.OnTimeFlag = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS OnTimePct, 94.0 AS Target,
           AVG(ds.DeliveryFee) AS AvgFee, SUM(CASE WHEN ds.BoomRequired = 1 THEN 1 ELSE 0 END) AS BoomStops
    FROM dbo.SwDeliveryStop ds JOIN dbo.SwOrder o ON o.orderID = ds.orderID LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
    WHERE ds.CompletedOn BETWEEN @from AND @to
    GROUP BY sp.Region
END
GO
