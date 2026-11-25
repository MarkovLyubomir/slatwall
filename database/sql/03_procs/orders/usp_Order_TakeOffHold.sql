/* =============================================================================
   Procedure: dbo.usp_Order_TakeOffHold
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Release an order from hold back to New. No authority check - the
              caller (counter app) is trusted.
   Change log:
     2016-06-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_TakeOffHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_TakeOffHold
GO
CREATE PROCEDURE dbo.usp_Order_TakeOffHold
    @orderID CHAR(32),
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwOrder SET orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostNew'), modifiedDateTime = GETDATE() WHERE orderID = @orderID
    INSERT dbo.SwOrderStatusLog (orderID, OldStatusCode, NewStatusCode, ChangedBy, Source) VALUES (@orderID, 'ostOnHold', 'ostNew', @byUser, 'usp_Order_TakeOffHold')
END
GO
