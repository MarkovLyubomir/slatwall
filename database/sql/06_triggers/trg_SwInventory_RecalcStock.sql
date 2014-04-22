/* =============================================================================
   Trigger:   dbo.trg_SwInventory_RecalcStock
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Keep SwStock.calculatedQOH in step with the ledger on every insert.
              Row-by-row (cursor over inserted) because "the batch recalc is
              the real one anyway".
   Change log:
     2014-04-22  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.trg_SwInventory_RecalcStock', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_SwInventory_RecalcStock
GO
CREATE TRIGGER dbo.trg_SwInventory_RecalcStock ON dbo.SwInventory
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32)
    DECLARE c CURSOR LOCAL FOR SELECT DISTINCT stockID FROM inserted
    OPEN c
    FETCH NEXT FROM c INTO @stockID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE dbo.SwStock SET calculatedQOH = dbo.fn_Stock_QOH(@stockID), modifiedDateTime = GETDATE() WHERE stockID = @stockID
        FETCH NEXT FROM c INTO @stockID
    END
    CLOSE c DEALLOCATE c
END
GO
