/* =============================================================================
   View:      dbo.vw_Rpt_OpenPicks
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Store pick board: open BOPIS / will-call tasks with SLA status.
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Rpt_OpenPicks', 'V') IS NOT NULL DROP VIEW dbo.vw_Rpt_OpenPicks
GO
CREATE VIEW dbo.vw_Rpt_OpenPicks AS
SELECT p.PickTaskID, p.StoreNumber, sp.StoreName, p.FulfillType, p.PickStatus, o.orderNumber, a.company, a.lastName, p.CreatedOn, p.SLADueOn,
       CASE WHEN p.PickStatus IN ('NEW','PICKING') AND p.SLADueOn < GETDATE() THEN 'LATE' WHEN p.PickStatus IN ('NEW','PICKING') AND p.SLADueOn < DATEADD(MINUTE, 30, GETDATE()) THEN 'DUE' ELSE 'OK' END AS SLAStatus,
       p.LineCount, p.ShortLineCount, p.StagingBay, p.AssignedTo
FROM dbo.SwPickTask p
JOIN dbo.SwOrderFulfillment f ON f.orderFulfillmentID = p.orderFulfillmentID
JOIN dbo.SwOrder o ON o.orderID = f.orderID
LEFT JOIN dbo.SwAccount a ON a.accountID = o.accountID
LEFT JOIN dbo.SwStoreProfile sp ON sp.StoreNumber = p.StoreNumber
WHERE p.PickStatus NOT IN ('COMPLETE','CANCELED','ABANDONED')
GO
