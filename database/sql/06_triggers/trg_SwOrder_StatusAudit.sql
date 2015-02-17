/* =============================================================================
   Trigger:   dbo.trg_SwOrder_StatusAudit
   Author:    Wade Hollister
   Created:   2015-02-17
   Purpose:   Log every status change to SwOrderStatusLog (in addition to the
              procs that also log, so most changes appear twice).
   Change log:
     2015-02-17  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwOrder_StatusAudit', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwOrder_StatusAudit
GO
CREATE TRIGGER dbo.trg_SwOrder_StatusAudit ON dbo.SwOrder
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    IF UPDATE(orderStatusTypeID)
        INSERT dbo.SwOrderStatusLog (orderID, OldStatusCode, NewStatusCode, ChangedBy, Source)
        SELECT i.orderID, td.systemCode, ti.systemCode, SUSER_SNAME(), 'trigger'
        FROM inserted i JOIN deleted d ON d.orderID = i.orderID
        LEFT JOIN dbo.SwType td ON td.typeID = d.orderStatusTypeID LEFT JOIN dbo.SwType ti ON ti.typeID = i.orderStatusTypeID
        WHERE ISNULL(i.orderStatusTypeID, '') <> ISNULL(d.orderStatusTypeID, '')
END
GO
