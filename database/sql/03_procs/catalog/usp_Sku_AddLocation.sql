/* =============================================================================
   Procedure: dbo.usp_Sku_AddLocation
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Stock a sku at a location (creates the SwStock row + location config).
   Change log:
     2014-04-22  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Sku_AddLocation', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Sku_AddLocation
GO
CREATE PROCEDURE dbo.usp_Sku_AddLocation
    @skuID CHAR(32),
    @locationID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    IF NOT EXISTS (SELECT 1 FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID)
        INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime) VALUES (dbo.fn_NewID32(), @skuID, @locationID, 0, 0, 0, GETDATE(), GETDATE())
END
GO
