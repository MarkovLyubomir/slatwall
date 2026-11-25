/* =============================================================================
   Procedure: dbo.usp_Catalog_ExportToAkeneo
   Author:    Priscilla Nance
   Created:   2022-11-07
   Purpose:   Push new/changed skus to Akeneo as a flat CSV (identifier, family,
              name, list price, uom). Akeneo owns commercial attributes after
              that; we never read them back except the commodity flag.
   Change log:
     2022-11-07  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Catalog_ExportToAkeneo', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Catalog_ExportToAkeneo
GO
CREATE PROCEDURE dbo.usp_Catalog_ExportToAkeneo
    @since DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @since IS NULL SET @since = DATEADD(DAY, -1, GETDATE())
    DECLARE @csv VARCHAR(MAX), @n INT
    SELECT @csv = 'sku;family;name;list_price;uom' + CHAR(10) + STUFF((
        SELECT CHAR(10) + s.skuCode + ';' + ISNULL(pt.systemCode, 'MISC') + ';"' + REPLACE(s.skuName, '"', '""') + '";' + CAST(s.listPrice AS VARCHAR(20)) + ';' + ISNULL(im.UOM, 'EA')
        FROM dbo.SwSku s JOIN dbo.SwProduct p ON p.productID = s.productID LEFT JOIN dbo.SwProductType pt ON pt.productTypeID = p.productTypeID LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
        WHERE s.modifiedDateTime >= @since FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 1, '')
    SELECT @n = COUNT(*) FROM dbo.SwSku WHERE modifiedDateTime >= @since
    INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status, ErrorText) VALUES ('AKENEO_PRODUCTS', 'OUT', 'akeneo_' + CONVERT(VARCHAR(8), GETDATE(), 112) + '.csv', @n, 'QUEUED', @csv)
END
GO
