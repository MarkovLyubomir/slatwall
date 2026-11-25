/* =============================================================================
   Procedure: dbo.usp_Delivery_ExportToDescartes
   Author:    Priscilla Nance
   Created:   2022-03-01
   Purpose:   Build the Descartes stop file (XML via FOR XML) for a route date and
              queue it. The XML schema is hand-built; Descartes v2 changed it
              in 2025 and we patched with REPLACE.
   Change log:
     2022-03-01  PN   Initial version
     2025-06-09  PN   v2 schema patch
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Delivery_ExportToDescartes', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Delivery_ExportToDescartes
GO
CREATE PROCEDURE dbo.usp_Delivery_ExportToDescartes
    @routeDate DATE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @xml NVARCHAR(MAX), @file VARCHAR(200), @n INT
    SELECT @xml = (
        SELECT ds.DeliveryStopID AS '@id', o.orderNumber AS 'Order', ad.streetAddress AS 'Address/Street', ad.city AS 'Address/City', ad.stateCode AS 'Address/State', ad.postalCode AS 'Address/Zip',
               ds.WindowStart AS 'Window/Start', ds.WindowEnd AS 'Window/End', ds.BoomRequired AS 'Equipment/Boom', ds.JobsiteContact AS 'Contact'
        FROM dbo.SwDeliveryStop ds JOIN dbo.SwOrder o ON o.orderID = ds.orderID LEFT JOIN dbo.SwAddress ad ON ad.addressID = o.shippingAddressID
        WHERE ds.PromisedDate = @routeDate AND ds.CompletedOn IS NULL
        FOR XML PATH('Stop'), ROOT('Stops'))
    SET @xml = REPLACE(@xml, '<Stops>', '<Stops version="2" tenant="SLATWALL">')   -- 2025-06-09
    SELECT @n = COUNT(*) FROM dbo.SwDeliveryStop WHERE PromisedDate = @routeDate AND CompletedOn IS NULL
    SET @file = 'DESC_' + CONVERT(VARCHAR(8), @routeDate, 112) + '.xml'
    INSERT dbo.SwIntegrationQueue (InterfaceCode, Direction, FileName, RecordCount, Status, ErrorText) VALUES ('DESCARTES_STOPS', 'OUT', @file, @n, 'QUEUED', @xml)   -- payload parked in ErrorText
END
GO
