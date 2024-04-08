/* =============================================================================
   View:      dbo.vw_Fivetran_StockPosition
   Author:    Priscilla Nance
   Created:   2024-04-08
   Purpose:   Daily stock position for Snowflake (IF-40). Ledger-based (correct)
              - so Snowflake disagrees with vw_BT_Inventory (cached) by design.
   Change log:
     2024-04-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Fivetran_StockPosition', 'V') IS NOT NULL DROP VIEW dbo.vw_Fivetran_StockPosition
GO
CREATE VIEW dbo.vw_Fivetran_StockPosition AS
SELECT st.stockID, s.skuCode, sp.StoreNumber, dc.DCCode, dbo.fn_Stock_QOH(st.stockID) AS QOH_Ledger, st.calculatedQOH AS QOH_Cached, dbo.fn_Stock_QATS(st.stockID) AS QATS_Ledger, st.calculatedQATS AS QATS_Cached
FROM dbo.SwStock st
JOIN dbo.SwSku s ON s.skuID = st.skuID
LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = st.locationID
LEFT JOIN dbo.SwDistributionCenter dc ON dc.locationID = st.locationID
GO
