/* =============================================================================
   Function:  dbo.fn_Sku_IsCommodity
   Author:    Wade Hollister
   Created:   2017-05-22
   Purpose:   Commodity lumber flag. Checks three places because nobody agreed on one.
   Change log:
     2017-05-22  WH   Initial version
     2022-11-07  WH   Also check the Akeneo attribute 'commodityFlag'
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Sku_IsCommodity') IS NOT NULL DROP FUNCTION dbo.fn_Sku_IsCommodity
GO
CREATE FUNCTION dbo.fn_Sku_IsCommodity(@skuID CHAR(32))
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.SwSkuCommodityLink WHERE skuID = @skuID) RETURN 1
    IF EXISTS (SELECT 1 FROM dbo.SwSku s JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode WHERE s.skuID = @skuID AND im.CommodityFlag = 1) RETURN 1
    IF EXISTS (SELECT 1 FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute a ON a.attributeID = av.attributeID
               WHERE av.skuID = @skuID AND a.attributeCode = 'commodityFlag' AND av.attributeValue IN ('1','true','Y'))
        RETURN 1
    RETURN 0
END
GO
