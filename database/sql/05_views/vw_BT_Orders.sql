/* =============================================================================
   View:      dbo.vw_BT_Orders
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Order header feed for BisTrack order import and 6 other external
              readers (interface register IF-02, IF-09, IF-14, IF-22, IF-31, IF-40).
              Read directly over a linked server by the BisTrack SSIS packages.
   Change log:
     2015-04-20  WH   Initial version
     2019-03-11  WH   Job account attribute
   ============================================================================= */
IF OBJECT_ID('dbo.vw_BT_Orders', 'V') IS NOT NULL DROP VIEW dbo.vw_BT_Orders
GO
CREATE VIEW dbo.vw_BT_Orders AS
SELECT o.orderID, o.orderNumber, o.remoteID AS SourceRef, oo.orderOriginType AS Channel, st.systemCode AS StatusCode,
       ISNULL(pa.BTCustomerNo, a.remoteID) AS BTCustomerNo, a.company, a.firstName, a.lastName,
       sp.StoreNumber, o.orderOpenDateTime, o.orderCloseDateTime, o.calculatedTotal,
       (SELECT TOP 1 av.attributeValue FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute at ON at.attributeID = av.attributeID WHERE av.orderID = o.orderID AND at.attributeCode = 'jobAccountID') AS JobAccountID,
       CASE WHEN EXISTS (SELECT 1 FROM dbo.SwOrderPayment op WHERE op.orderID = o.orderID AND op.paymentTermID IS NOT NULL) THEN 'TERMS' ELSE 'PAID' END AS PaymentMode
FROM dbo.SwOrder o WITH (NOLOCK)
JOIN dbo.SwType st ON st.typeID = o.orderStatusTypeID
LEFT JOIN dbo.SwOrderOrigin oo ON oo.orderOriginID = o.orderOriginID
LEFT JOIN dbo.SwAccount a ON a.accountID = o.accountID
LEFT JOIN dbo.SwProAccount pa ON pa.accountID = o.accountID AND pa.ActiveFlag = 1
LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
WHERE o.orderNumber IS NOT NULL
GO
