/* =============================================================================
   Procedure: dbo.usp_Stock_GetQATS
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Available-to-sell for a sku at a location (ledger based). Availability
              calculation #1; usp_Web_SyncInventory is #2 and reads the cache.
   Change log:
     2014-04-22  WH   Initial version
     2019-10-08  PN   Holds
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_GetQATS', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_GetQATS
GO
CREATE PROCEDURE dbo.usp_Stock_GetQATS
    @skuID CHAR(32),
    @locationID CHAR(32),
    @qats INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32)
    SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
    SET @qats = ISNULL(dbo.fn_Stock_QATS(@stockID), 0)
END
GO
