/* =============================================================================
   Procedure: dbo.usp_Price_ImportZonePrices
   Author:    Wade Hollister
   Created:   2016-11-07
   Purpose:   Load the nightly BisTrack zone price file (staged in a temp table
              by the SSIS package) into SwZonePrice. MERGE with no HOLDLOCK.
   Change log:
     2016-11-07  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_ImportZonePrices', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_ImportZonePrices
GO
CREATE PROCEDURE dbo.usp_Price_ImportZonePrices
    @effectiveDate DATE
AS
BEGIN
    SET NOCOUNT ON
    IF OBJECT_ID('tempdb..##BT_ZonePrice') IS NULL
    BEGIN
        RAISERROR('Staging table ##BT_ZonePrice not found - SSIS step 3 did not run', 16, 1)
        RETURN
    END
    MERGE dbo.SwZonePrice AS tgt
    USING (SELECT s.skuID, z.Zone, z.Price FROM ##BT_ZonePrice z JOIN dbo.SwSku s ON s.skuCode = z.ItemNo) AS src
        ON tgt.skuID = src.skuID AND tgt.PriceZone = src.Zone AND tgt.EndDate IS NULL
    WHEN MATCHED AND tgt.ZonePrice <> src.Price THEN UPDATE SET ZonePrice = src.Price, EffectiveDate = @effectiveDate, UpdatedOn = GETDATE(), UpdatedBy = 'BT_IMPORT'
    WHEN NOT MATCHED THEN INSERT (skuID, PriceZone, ZonePrice, EffectiveDate, SourceSystem) VALUES (src.skuID, src.Zone, src.Price, @effectiveDate, 'BT');
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Price_ImportZonePrices', 'merge', @@ROWCOUNT, 'OK', GETDATE())
END
GO
