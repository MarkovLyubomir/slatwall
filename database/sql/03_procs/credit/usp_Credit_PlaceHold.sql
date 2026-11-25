/* =============================================================================
   Procedure: dbo.usp_Credit_PlaceHold
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Place a credit hold on a pro account and put its open orders on hold.
   Change log:
     2016-06-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_PlaceHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_PlaceHold
GO
CREATE PROCEDURE dbo.usp_Credit_PlaceHold
    @proAccountID INT,
    @reason VARCHAR(20),         -- OVERLIMIT, PASTDUE, NSF, MANUAL, LIEN
    @byUser VARCHAR(50),
    @notes VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @orderID CHAR(32)
    SELECT @accountID = accountID FROM dbo.SwProAccount WHERE ProAccountID = @proAccountID
    INSERT dbo.SwCreditHold (ProAccountID, HoldReason, HoldBy, ExposureAtHold, Notes) VALUES (@proAccountID, @reason, @byUser, dbo.fn_Credit_Exposure(@proAccountID), @notes)
    DECLARE c CURSOR LOCAL FOR SELECT orderID FROM dbo.SwOrder WHERE accountID = @accountID AND orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostNew')
      AND orderID IN (SELECT orderID FROM dbo.SwOrderPayment WHERE paymentTermID IS NOT NULL)
    OPEN c
    FETCH NEXT FROM c INTO @orderID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Order_PlaceOnHold @orderID = @orderID, @reason = @reason, @byUser = @byUser
        FETCH NEXT FROM c INTO @orderID
    END
    CLOSE c DEALLOCATE c
END
GO
