/* =============================================================================
   Procedure: dbo.usp_Web_SyncProduct
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Build the Adobe product payload (JSON by string concat) for queued
              skus. Attributes come from the EAV table, one subquery each.
   Change log:
     2018-11-26  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Web_SyncProduct', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Web_SyncProduct
GO
CREATE PROCEDURE dbo.usp_Web_SyncProduct
AS
BEGIN
    SET NOCOUNT ON
    UPDATE w SET w.Payload = '{"sku":"' + s.skuCode + '","name":"' + REPLACE(s.skuName, '"', '\"') + '","price":' + CAST(s.price AS VARCHAR(20))
                            + ',"status":' + CASE WHEN s.publishedFlag = 1 THEN '1' ELSE '2' END
                            + ',"weight":' + ISNULL(CAST(im.Weight AS VARCHAR(20)), '0')
                            + ',"custom_attributes":[{"attribute_code":"length_ft","value":"' + ISNULL((SELECT TOP 1 av.attributeValue FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute a ON a.attributeID = av.attributeID WHERE av.skuID = s.skuID AND a.attributeCode = 'lengthFeet'), '') + '"},'
                            + '{"attribute_code":"treatment","value":"' + ISNULL((SELECT TOP 1 av.attributeValue FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute a ON a.attributeID = av.attributeID WHERE av.skuID = s.skuID AND a.attributeCode = 'treatmentType'), '') + '"},'
                            + '{"attribute_code":"private_label","value":"' + ISNULL(im.PrivateLabelCode, '') + '"}]}',
                 w.AdobeSku = s.skuCode
    FROM dbo.SwWebSync_Product w JOIN dbo.SwSku s ON s.skuID = w.skuID LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
    WHERE w.Status = 'PENDING' AND w.Payload IS NULL
    INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status) SELECT 'ADOBE_PRODUCT', 'OUT', 'prod_' + CONVERT(VARCHAR(8), GETDATE(), 112) + '.json', COUNT(*), 'QUEUED' FROM dbo.SwWebSync_Product WHERE Status = 'PENDING'
END
GO
