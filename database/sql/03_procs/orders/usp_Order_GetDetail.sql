/* =============================================================================
   Procedure: dbo.usp_Order_GetDetail
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Order header + lines for the admin and the counter app (SELECT *).
   Change log:
     2014-06-12  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_GetDetail', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_GetDetail
GO
CREATE PROCEDURE dbo.usp_Order_GetDetail
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    SELECT o.*, st.systemCode AS orderStatusCode, a.firstName, a.lastName, a.company FROM dbo.SwOrder o WITH (NOLOCK)
    JOIN dbo.SwType st ON st.typeID = o.orderStatusTypeID
    LEFT JOIN dbo.SwAccount a ON a.accountID = o.accountID WHERE o.orderID = @orderID
    SELECT oi.*, s.skuCode, s.skuName, p.productName FROM dbo.SwOrderItem oi WITH (NOLOCK)
    JOIN dbo.SwSku s ON s.skuID = oi.skuID JOIN dbo.SwProduct p ON p.productID = s.productID WHERE oi.orderID = @orderID
    SELECT * FROM dbo.SwOrderPayment WITH (NOLOCK) WHERE orderID = @orderID
    SELECT * FROM dbo.SwOrderFulfillment WITH (NOLOCK) WHERE orderID = @orderID
END
GO
