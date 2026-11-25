/* =============================================================================
   View:      dbo.vw_BT_OrderLines
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Order line feed for BisTrack (IF-02) and the Snowflake stopgap (IF-40).
   Change log:
     2015-04-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_BT_OrderLines', 'V') IS NOT NULL DROP VIEW dbo.vw_BT_OrderLines
GO
CREATE VIEW dbo.vw_BT_OrderLines AS
SELECT oi.orderItemID, oi.orderID, o.orderNumber, s.skuCode AS ItemNo, oi.quantity, oi.price, oi.skuPrice AS ListPriceAtSale, pg.priceGroupCode,
       ISNULL((SELECT SUM(odi.quantity) FROM dbo.SwOrderDeliveryItem odi WHERE odi.orderItemID = oi.orderItemID), 0) AS DeliveredQty,
       ISNULL((SELECT SUM(ta.taxAmount) FROM dbo.SwTaxApplied ta WHERE ta.orderItemID = oi.orderItemID), 0) AS TaxAmount,
       ISNULL((SELECT SUM(pa.discountAmount) FROM dbo.SwPromotionApplied pa WHERE pa.orderItemID = oi.orderItemID), 0) AS DiscountAmount
FROM dbo.SwOrderItem oi WITH (NOLOCK)
JOIN dbo.SwOrder o WITH (NOLOCK) ON o.orderID = oi.orderID
JOIN dbo.SwSku s ON s.skuID = oi.skuID
LEFT JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = oi.appliedPriceGroupID
WHERE o.orderNumber IS NOT NULL
GO
