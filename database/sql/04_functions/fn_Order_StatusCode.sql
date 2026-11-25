/* =============================================================================
   Function:  dbo.fn_Order_StatusCode
   Author:    Wade Hollister
   Created:   2015-02-17
   Purpose:   Human readable status code for an order (joins SwType twice).
   Change log:
     2015-02-17  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Order_StatusCode') IS NOT NULL DROP FUNCTION dbo.fn_Order_StatusCode
GO
CREATE FUNCTION dbo.fn_Order_StatusCode(@orderID CHAR(32))
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN (SELECT t.systemCode FROM dbo.SwOrder o JOIN dbo.SwType t ON t.typeID = o.orderStatusTypeID WHERE o.orderID = @orderID)
END
GO
