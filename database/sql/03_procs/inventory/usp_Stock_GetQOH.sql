/* =============================================================================
   Procedure: dbo.usp_Stock_GetQOH
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   QOH for a sku at a location - from the ledger (slow, correct).
   Change log:
     2014-04-22  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_GetQOH', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_GetQOH
GO
CREATE PROCEDURE dbo.usp_Stock_GetQOH
    @skuID CHAR(32),
    @locationID CHAR(32),
    @qoh INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32)
    SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
    SET @qoh = ISNULL(dbo.fn_Stock_QOH(@stockID), 0)
END
GO
