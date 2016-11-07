/* =============================================================================
   Procedure: dbo.usp_Price_ApplyZone
   Author:    Wade Hollister
   Created:   2016-11-07
   Purpose:   Bulk-generate zone prices from a base zone with a percentage uplift
              (merch "push to zones" button). Writes SwZonePrice rows per sku.
   Change log:
     2016-11-07  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_ApplyZone', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_ApplyZone
GO
CREATE PROCEDURE dbo.usp_Price_ApplyZone
    @fromZone CHAR(1),
    @toZone CHAR(1),
    @upliftPct DECIMAL(5,2),
    @effectiveDate DATE,
    @productTypeID CHAR(32) = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRAN
    UPDATE zp SET EndDate = DATEADD(DAY, -1, @effectiveDate), UpdatedOn = GETDATE(), UpdatedBy = SUSER_SNAME()
    FROM dbo.SwZonePrice zp
    WHERE zp.PriceZone = @toZone AND zp.EndDate IS NULL
      AND (@productTypeID IS NULL OR zp.skuID IN (SELECT s.skuID FROM dbo.SwSku s JOIN dbo.SwProduct p ON p.productID = s.productID WHERE p.productTypeID = @productTypeID))

    INSERT dbo.SwZonePrice (skuID, PriceZone, ZonePrice, EffectiveDate, SourceSystem)
    SELECT zp.skuID, @toZone, ROUND(zp.ZonePrice * (1 + @upliftPct / 100.0), 2), @effectiveDate, 'SWC'
    FROM dbo.SwZonePrice zp
    WHERE zp.PriceZone = @fromZone AND zp.EndDate IS NULL
      AND (@productTypeID IS NULL OR zp.skuID IN (SELECT s.skuID FROM dbo.SwSku s JOIN dbo.SwProduct p ON p.productID = s.productID WHERE p.productTypeID = @productTypeID))
    COMMIT
    -- web price book needs the new numbers too
    INSERT dbo.SwWebSync_Price (skuID, PriceZone, CustomerGroup, WebPrice)
    SELECT skuID, @toZone, 'RETAIL', ZonePrice FROM dbo.SwZonePrice WHERE PriceZone = @toZone AND EffectiveDate = @effectiveDate
END
GO
