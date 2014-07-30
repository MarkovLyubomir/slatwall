/* =============================================================================
   Procedure: dbo.usp_Task_Run
   Author:    Wade Hollister
   Created:   2014-07-30
   Purpose:   Run a Slatwall task row by name: SwTask.taskMethod is the name of
              a stored procedure (!) executed via dynamic SQL, with history.
   Change log:
     2014-07-30  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Task_Run', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Task_Run
GO
CREATE PROCEDURE dbo.usp_Task_Run
    @taskName VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @taskID CHAR(32), @method VARCHAR(255), @histID CHAR(32), @ok BIT = 1, @resp VARCHAR(255), @start DATETIME = GETDATE()
    SELECT @taskID = taskID, @method = taskMethod FROM dbo.SwTask WHERE taskName = @taskName AND activeFlag = 1
    IF @taskID IS NULL RETURN
    IF EXISTS (SELECT 1 FROM dbo.SwTask WHERE taskID = @taskID AND runningFlag = 1) RETURN   -- stuck forever if a run died
    UPDATE dbo.SwTask SET runningFlag = 1 WHERE taskID = @taskID
    BEGIN TRY
        EXEC ('EXEC dbo.' + @method)
    END TRY
    BEGIN CATCH
        SET @ok = 0
        SET @resp = LEFT(ERROR_MESSAGE(), 255)
    END CATCH
    UPDATE dbo.SwTask SET runningFlag = 0 WHERE taskID = @taskID
    INSERT dbo.SwTaskHistory (taskHistoryID, successFlag, response, startTime, endTime, taskID, createdDateTime) VALUES (dbo.fn_NewID32(), @ok, @resp, @start, GETDATE(), @taskID, GETDATE())
END
GO
