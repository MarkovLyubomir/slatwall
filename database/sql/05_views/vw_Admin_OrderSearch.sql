/* =============================================================================
   View:      dbo.vw_Admin_OrderSearch
   Author:    Wade Hollister
   Created:   2015-02-17
   Purpose:   Admin order grid (SELECT * over 6 joins, no filters; the admin
              adds WHERE in the app).
   Change log:
     2015-02-17  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Admin_OrderSearch', 'V') IS NOT NULL DROP VIEW dbo.vw_Admin_OrderSearch
GO
CREATE VIEW dbo.vw_Admin_OrderSearch AS
SELECT o.*, st.systemCode AS statusCode, ot.systemCode AS orderTypeCode, oo.orderOriginType, a.firstName, a.lastName, a.company, sp.StoreNumber, sp.StoreName,
       (SELECT COUNT(*) FROM dbo.SwOrderItem oi WHERE oi.orderID = o.orderID) AS lineCount
FROM dbo.SwOrder o WITH (NOLOCK)
JOIN dbo.SwType st ON st.typeID = o.orderStatusTypeID
JOIN dbo.SwType ot ON ot.typeID = o.orderTypeID
LEFT JOIN dbo.SwOrderOrigin oo ON oo.orderOriginID = o.orderOriginID
LEFT JOIN dbo.SwAccount a ON a.accountID = o.accountID
LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
GO
