/* =============================================================================
   View:      dbo.vw_BT_Inventory
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Stock position per item/branch for external readers (IF-05 BisTrack
              reconcile, IF-11 Descartes, IF-18 Power BI direct query, IF-33 Akeneo).
              Returns the CACHED numbers.
   Change log:
     2015-04-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_BT_Inventory', 'V') IS NOT NULL DROP VIEW dbo.vw_BT_Inventory
GO
CREATE VIEW dbo.vw_BT_Inventory AS
SELECT s.skuCode AS ItemNo, ISNULL(CAST(sp.StoreNumber AS VARCHAR(5)), dc.DCCode) AS Branch, st.calculatedQOH AS QOH, st.calculatedQATS AS QATS, st.calculatedQNC AS QNC,
       st.modifiedDateTime AS LastRecalc, im.AvgCost, st.calculatedQOH * ISNULL(im.AvgCost, 0) AS ExtendedCost
FROM dbo.SwStock st WITH (NOLOCK)
JOIN dbo.SwSku s ON s.skuID = st.skuID
LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = st.locationID
LEFT JOIN dbo.SwDistributionCenter dc ON dc.locationID = st.locationID
LEFT JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode
GO
