/* =============================================================================
   Trigger:   dbo.trg_SwSku_WebSync
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Queue a product sync when price/name/published changes.
   Change log:
     2018-11-26  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwSku_WebSync', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwSku_WebSync
GO
CREATE TRIGGER dbo.trg_SwSku_WebSync ON dbo.SwSku
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    IF UPDATE(price) OR UPDATE(skuName) OR UPDATE(publishedFlag) OR UPDATE(activeFlag)
        INSERT dbo.SwWebSync_Product (skuID, Action) SELECT skuID, 'UPDATE' FROM inserted
END
GO
