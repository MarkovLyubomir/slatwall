/* =============================================================================
   Procedure: dbo.usp_Rpt_FillRate
   Author:    Priscilla Nance
   Created:   2018-01-09
   Purpose:   Line fill rate: order lines delivered in full from stock on first
              delivery / total lines. Target 96%. Counts BOPIS short picks as
              fills if the transfer eventually arrived.
   Change log:
     2018-01-09  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_FillRate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_FillRate
GO
CREATE PROCEDURE dbo.usp_Rpt_FillRate
    @from DATE,
    @to DATE
AS
BEGIN
    SET NOCOUNT ON
    SELECT sp.Region, sp.StoreNumber,
           COUNT(oi.orderItemID) AS Lines,
           SUM(CASE WHEN d.firstQty >= oi.quantity THEN 1 ELSE 0 END) AS FilledLines,
           ROUND(100.0 * SUM(CASE WHEN d.firstQty >= oi.quantity THEN 1 ELSE 0 END) / NULLIF(COUNT(oi.orderItemID), 0), 2) AS FillRatePct, 96.0 AS Target
    FROM dbo.SwOrderItem oi JOIN dbo.SwOrder o ON o.orderID = oi.orderID JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
    LEFT JOIN (SELECT odi.orderItemID, SUM(odi.quantity) AS firstQty FROM dbo.SwOrderDeliveryItem odi
               JOIN (SELECT orderItemID, MIN(createdDateTime) AS firstDt FROM dbo.SwOrderDeliveryItem GROUP BY orderItemID) f ON f.orderItemID = odi.orderItemID AND f.firstDt = odi.createdDateTime
               GROUP BY odi.orderItemID) d ON d.orderItemID = oi.orderItemID
    WHERE o.orderOpenDateTime BETWEEN @from AND @to AND o.orderNumber IS NOT NULL AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
    GROUP BY sp.Region, sp.StoreNumber
    ORDER BY sp.Region, sp.StoreNumber
END
GO
