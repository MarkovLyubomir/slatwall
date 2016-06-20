/* =============================================================================
   Procedure: dbo.usp_Order_PlaceOnHold
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Move an order to OnHold (credit, fraud, stock).
   Change log:
     2016-06-20  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_PlaceOnHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_PlaceOnHold
GO
CREATE PROCEDURE dbo.usp_Order_PlaceOnHold
    @orderID CHAR(32),
    @reason VARCHAR(50),
    @byUser VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwOrder SET orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostOnHold'), modifiedDateTime = GETDATE() WHERE orderID = @orderID
    INSERT dbo.SwOrderStatusLog (orderID, OldStatusCode, NewStatusCode, ChangedBy, Source) VALUES (@orderID, NULL, 'ostOnHold:' + @reason, @byUser, 'usp_Order_PlaceOnHold')
END
GO
