/* =============================================================================
   Procedure: dbo.usp_Stock_CreateHold
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Hold stock for an order item (BOPIS) for @hours.
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_CreateHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_CreateHold
GO
CREATE PROCEDURE dbo.usp_Stock_CreateHold
    @orderItemID CHAR(32),
    @hours INT = 72
AS
BEGIN
    SET NOCOUNT ON
    INSERT dbo.SwStockHold (stockHoldID, stockHoldExpirationDateTime, orderItemID, skuID, stockID, createdDateTime)
    SELECT dbo.fn_NewID32(), DATEADD(HOUR, @hours, GETDATE()), orderItemID, skuID, stockID, GETDATE() FROM dbo.SwOrderItem WHERE orderItemID = @orderItemID
END
GO
