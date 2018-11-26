/* =============================================================================
   View:      dbo.vw_Web_ProductFeed
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Flat product feed Adobe's importer reads directly (IF-12) - the
              third copy of the catalog after SwProduct/SwSku and SwItemMaster_BT.
   Change log:
     2018-11-26  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Web_ProductFeed', 'V') IS NOT NULL DROP VIEW dbo.vw_Web_ProductFeed
GO
CREATE VIEW dbo.vw_Web_ProductFeed AS
SELECT s.skuCode AS sku, s.skuName AS name, p.productName, pt.productTypeName AS category, b.brandName AS brand, s.price, s.listPrice, s.publishedFlag AS status,
       im.UOM, im.Weight, im.LengthFt, im.PrivateLabelCode, s.calculatedQATS AS qty, p.urlTitle, s.modifiedDateTime
FROM dbo.SwSku s WITH (NOLOCK)
JOIN dbo.SwProduct p ON p.productID = s.productID
LEFT JOIN dbo.SwProductType pt ON pt.productTypeID = p.productTypeID
LEFT JOIN dbo.SwBrand b ON b.brandID = p.brandID
LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
WHERE s.activeFlag = 1
GO
