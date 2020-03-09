/* =============================================================================
   Trigger:   dbo.trg_SwZonePrice_WebSync
   Author:    Priscilla Nance
   Created:   2019-08-26
   Purpose:   Queue a web price when a zone price changes. DISABLED 2020-03-09
              (web gets prices from usp_Web_SyncPriceBook now) but never dropped.
   Change log:
     2019-08-26  PN   Initial version
     2020-03-09  PN   Disabled
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwZonePrice_WebSync', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwZonePrice_WebSync
GO
CREATE TRIGGER dbo.trg_SwZonePrice_WebSync ON dbo.SwZonePrice
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON
    INSERT dbo.SwWebSync_Price (skuID, PriceZone, CustomerGroup, WebPrice) SELECT skuID, PriceZone, 'RETAIL', ZonePrice FROM inserted
END
GO
DISABLE TRIGGER dbo.trg_SwZonePrice_WebSync ON dbo.SwZonePrice
GO
