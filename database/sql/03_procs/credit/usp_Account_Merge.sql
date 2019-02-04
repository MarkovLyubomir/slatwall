/* =============================================================================
   Procedure: dbo.usp_Account_Merge
   Author:    Wade Hollister
   Created:   2019-02-04
   Purpose:   Merge duplicate accounts (web + counter + Salesforce created
              three records for the same builder). Re-points every FK column
              named accountID in the database via dynamic SQL from sys.columns.
   WARNING:   Runs against every table with an accountID column, including
              ones that are not customers (createdByAccountID is excluded by
              name only).
   Change log:
     2019-02-04  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Account_Merge', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Account_Merge
GO
CREATE PROCEDURE dbo.usp_Account_Merge
    @survivorAccountID CHAR(32),
    @victimAccountID CHAR(32),
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @tbl SYSNAME, @col SYSNAME, @sql NVARCHAR(MAX)
    IF @survivorAccountID = @victimAccountID RETURN
    BEGIN TRAN
    DECLARE c CURSOR LOCAL FOR
        SELECT t.name, c.name FROM sys.columns c JOIN sys.tables t ON t.object_id = c.object_id
        WHERE c.name IN ('accountID','ownerAccountID','relatedAccountID','termPaymentAccountID','assignedAccountID') AND t.name <> 'SwAccount'
    OPEN c
    FETCH NEXT FROM c INTO @tbl, @col
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'UPDATE dbo.' + QUOTENAME(@tbl) + N' SET ' + QUOTENAME(@col) + N' = ''' + @survivorAccountID + N''' WHERE ' + QUOTENAME(@col) + N' = ''' + @victimAccountID + N''''
        EXEC sp_executesql @sql
        FETCH NEXT FROM c INTO @tbl, @col
    END
    CLOSE c DEALLOCATE c
    -- keep victim's remote ids if survivor lacks them
    UPDATE s SET s.remoteID = ISNULL(s.remoteID, v.remoteID), s.remoteCustomerID = ISNULL(s.remoteCustomerID, v.remoteCustomerID), s.remoteContactID = ISNULL(s.remoteContactID, v.remoteContactID)
    FROM dbo.SwAccount s CROSS JOIN dbo.SwAccount v WHERE s.accountID = @survivorAccountID AND v.accountID = @victimAccountID
    UPDATE dbo.SwProAccount SET ActiveFlag = 0, UpdatedOn = GETDATE(), UpdatedBy = @byUser WHERE accountID = @survivorAccountID AND ProAccountID NOT IN (SELECT MIN(ProAccountID) FROM dbo.SwProAccount WHERE accountID = @survivorAccountID)
    DELETE dbo.SwAccount WHERE accountID = @victimAccountID
    COMMIT
    INSERT dbo.SwETL_Log (JobName, StepName, Status, Message, RunBy) VALUES ('usp_Account_Merge', @victimAccountID, 'OK', 'merged into ' + @survivorAccountID, @byUser)
END
GO
