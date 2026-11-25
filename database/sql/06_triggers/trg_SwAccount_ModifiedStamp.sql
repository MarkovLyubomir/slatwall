/* =============================================================================
   Trigger:   dbo.trg_SwAccount_ModifiedStamp
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Stamp modifiedDateTime (the ORM did this; the procs don't always).
   Change log:
     2014-03-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwAccount_ModifiedStamp', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwAccount_ModifiedStamp
GO
CREATE TRIGGER dbo.trg_SwAccount_ModifiedStamp ON dbo.SwAccount
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    UPDATE a SET modifiedDateTime = GETDATE() FROM dbo.SwAccount a JOIN inserted i ON i.accountID = a.accountID
END
GO
