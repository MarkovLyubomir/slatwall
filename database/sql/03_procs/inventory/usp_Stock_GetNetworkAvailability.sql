/* =============================================================================
   Procedure: dbo.usp_Stock_GetNetworkAvailability
   Author:    Priscilla Nance
   Created:   2021-03-08
   Purpose:   "Find in store" on the web: availability of a sku at every store
              and DC. Runs fn_Stock_QATS 16 times per call, per sku, per page view.
   Change log:
     2021-03-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_GetNetworkAvailability', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_GetNetworkAvailability
GO
CREATE PROCEDURE dbo.usp_Stock_GetNetworkAvailability
    @skuID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    SELECT sp.StoreNumber, sp.StoreName, sp.Region, st.stockID, dbo.fn_Stock_QATS(st.stockID) AS QATS, st.calculatedQATS AS CachedQATS
    FROM dbo.SwStoreProfile sp LEFT JOIN dbo.SwStock st ON st.locationID = sp.locationID AND st.skuID = @skuID
    WHERE sp.ActiveFlag = 1
    UNION ALL
    SELECT 90 + dc.DCID, dc.DCName, 'DC', st.stockID, dbo.fn_Stock_QATS(st.stockID), st.calculatedQATS
    FROM dbo.SwDistributionCenter dc LEFT JOIN dbo.SwStock st ON st.locationID = dc.locationID AND st.skuID = @skuID
    ORDER BY 1
END
GO
