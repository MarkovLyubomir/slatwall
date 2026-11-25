/* =============================================================================
   Procedure: dbo.usp_Session_Cleanup
   Author:    Wade Hollister
   Created:   2015-06-08
   Purpose:   Delete expired web sessions and orphan NotPlaced carts older than 30 days.
   Change log:
     2015-06-08  WH   Initial version
     2019-06-17  PN   Keep carts with a pro account (they come back)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Session_Cleanup', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Session_Cleanup
GO
CREATE PROCEDURE dbo.usp_Session_Cleanup
AS
BEGIN
    SET NOCOUNT ON
    DELETE dbo.SwSession WHERE sessionExpirationDateTime < DATEADD(DAY, -7, GETDATE())
    DECLARE @orderID CHAR(32)
    DECLARE c CURSOR LOCAL FOR
        SELECT o.orderID FROM dbo.SwOrder o
        WHERE o.orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostNotPlaced') AND o.modifiedDateTime < DATEADD(DAY, -30, GETDATE())
          AND NOT EXISTS (SELECT 1 FROM dbo.SwProAccount pa WHERE pa.accountID = o.accountID AND pa.ActiveFlag = 1)
    OPEN c
    FETCH NEXT FROM c INTO @orderID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Order_Clear @orderID
        DELETE dbo.SwOrder WHERE orderID = @orderID
        FETCH NEXT FROM c INTO @orderID
    END
    CLOSE c DEALLOCATE c
END
GO
