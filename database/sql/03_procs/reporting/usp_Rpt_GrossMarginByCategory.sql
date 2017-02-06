/* =============================================================================
   Procedure: dbo.usp_Rpt_GrossMarginByCategory
   Author:    Priscilla Nance
   Created:   2017-02-06
   Purpose:   GM% by product type for a date range. Cost = SwItemMaster_BT.AvgCost
              as of today, not as of sale (so margin history moves when cost moves).
   Change log:
     2017-02-06  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_GrossMarginByCategory', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_GrossMarginByCategory
GO
CREATE PROCEDURE dbo.usp_Rpt_GrossMarginByCategory
    @from DATE,
    @to DATE
AS
BEGIN
    SET NOCOUNT ON
    SELECT pt.productTypeName AS Category,
           SUM(oi.price * oi.quantity) AS Sales,
           SUM(ISNULL(im.AvgCost, 0) * oi.quantity) AS Cost,
           SUM(oi.price * oi.quantity) - SUM(ISNULL(im.AvgCost, 0) * oi.quantity) AS GrossMargin,
           CASE WHEN SUM(oi.price * oi.quantity) > 0 THEN ROUND(100.0 * (1 - SUM(ISNULL(im.AvgCost, 0) * oi.quantity) / SUM(oi.price * oi.quantity)), 2) END AS GMPct,
           SUM(CASE WHEN pl.PrivateLabelCode IS NOT NULL THEN oi.price * oi.quantity ELSE 0 END) AS PrivateLabelSales
    FROM dbo.SwOrderItem oi WITH (NOLOCK) JOIN dbo.SwOrder o WITH (NOLOCK) ON o.orderID = oi.orderID
    JOIN dbo.SwSku s ON s.skuID = oi.skuID JOIN dbo.SwProduct p ON p.productID = s.productID JOIN dbo.SwProductType pt ON pt.productTypeID = p.productTypeID
    LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode LEFT JOIN dbo.SwPrivateLabelProgram pl ON pl.brandID = p.brandID
    WHERE o.orderOpenDateTime BETWEEN @from AND @to AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale') AND o.orderNumber IS NOT NULL
    GROUP BY pt.productTypeName
    ORDER BY Sales DESC
END
GO
