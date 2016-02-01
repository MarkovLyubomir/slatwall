/* =============================================================================
   Procedure: dbo.usp_Account_SyncFromBisTrack
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Nightly customer sync from the BisTrack customer extract (staged
              in ##BT_Customer by SSIS). Matches on BTCustomerNo, then company
              name - the source of most duplicate accounts.
   Change log:
     2015-04-20  WH   Initial version
     2016-02-01  WH   Create SwProAccount for trade customers
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Account_SyncFromBisTrack', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Account_SyncFromBisTrack
GO
CREATE PROCEDURE dbo.usp_Account_SyncFromBisTrack
AS
BEGIN
    SET NOCOUNT ON
    IF OBJECT_ID('tempdb..##BT_Customer') IS NULL RETURN
    DECLARE @custNo VARCHAR(20), @name VARCHAR(255), @trade VARCHAR(30), @store TINYINT, @email VARCHAR(255), @accountID CHAR(32), @pa INT, @n INT = 0
    DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT CustNo, CustName, TradeType, HomeStore, Email FROM ##BT_Customer
    OPEN c
    FETCH NEXT FROM c INTO @custNo, @name, @trade, @store, @email
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @accountID = NULL
        SELECT TOP 1 @accountID = accountID FROM dbo.SwProAccount WHERE BTCustomerNo = @custNo
        IF @accountID IS NULL SELECT TOP 1 @accountID = accountID FROM dbo.SwAccount WHERE remoteID = @custNo
        -- IF @accountID IS NULL SELECT TOP 1 @accountID = accountID FROM dbo.SwAccount WHERE company = @name   -- 2023-05-15 disabled
        IF @accountID IS NULL
        BEGIN
            EXEC dbo.usp_Account_Create @company = @name, @emailAddress = @email, @remoteID = @custNo, @accountID = @accountID OUTPUT
            SET @n = @n + 1
        END
        ELSE
            UPDATE dbo.SwAccount SET company = @name, modifiedDateTime = GETDATE(), modifiedByAccountID = 'BT_SYNC' WHERE accountID = @accountID
        IF @trade IS NOT NULL AND @trade <> ''
            EXEC dbo.usp_Pro_CreateProAccount @accountID = @accountID, @btCustomerNo = @custNo, @tradeType = @trade, @homeStoreNumber = @store, @proAccountID = @pa OUTPUT
        FETCH NEXT FROM c INTO @custNo, @name, @trade, @store, @email
    END
    CLOSE c DEALLOCATE c
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Account_SyncFromBisTrack', 'created', @n, 'OK', GETDATE())
END
GO
