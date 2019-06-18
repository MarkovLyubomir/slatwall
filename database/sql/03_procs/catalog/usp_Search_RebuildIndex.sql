/* =============================================================================
   Procedure: dbo.usp_Search_RebuildIndex
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Rebuild the admin "quick search" keyword column: concatenates sku
              code, alternate codes, name, brand and attribute values into
              SwSku.skuDescription (yes, overwrites the description).
   Change log:
     2019-06-17  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Search_RebuildIndex', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Search_RebuildIndex
GO
CREATE PROCEDURE dbo.usp_Search_RebuildIndex
AS
BEGIN
    SET NOCOUNT ON
    UPDATE s SET s.skuDescription = LEFT(
        s.skuCode + ' ' + ISNULL(b.brandName, '') + ' ' + s.skuName + ' '
        + ISNULL((SELECT STUFF((SELECT ' ' + a.alternateSkuCode FROM dbo.SwAlternateSkuCode a WHERE a.skuID = s.skuID FOR XML PATH('')), 1, 1, '')), '')
        + ' ' + ISNULL((SELECT STUFF((SELECT ' ' + av.attributeValue FROM dbo.SwAttributeValue av WHERE av.skuID = s.skuID FOR XML PATH('')), 1, 1, '')), ''), 4000)
    FROM dbo.SwSku s JOIN dbo.SwProduct p ON p.productID = s.productID LEFT JOIN dbo.SwBrand b ON b.brandID = p.brandID
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Search_RebuildIndex', 'rebuild', @@ROWCOUNT, 'OK', GETDATE())
END
GO
