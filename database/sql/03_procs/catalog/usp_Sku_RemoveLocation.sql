/* =============================================================================
   Procedure: dbo.usp_Sku_RemoveLocation
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Un-stock a sku at a location. Deletes the stock row if the ledger
              nets to zero; otherwise leaves it and sets QATS to 0 on the cache.
   Change log:
     2014-04-22  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Sku_RemoveLocation', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Sku_RemoveLocation
GO
CREATE PROCEDURE dbo.usp_Sku_RemoveLocation
    @skuID CHAR(32),
    @locationID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32)
    SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
    IF @stockID IS NULL RETURN
    IF dbo.fn_Stock_QOH(@stockID) = 0 AND NOT EXISTS (SELECT 1 FROM dbo.SwOrderItem WHERE stockID = @stockID)
    BEGIN
        DELETE dbo.SwInventory WHERE stockID = @stockID
        DELETE dbo.SwStock WHERE stockID = @stockID
    END
    ELSE
        UPDATE dbo.SwStock SET calculatedQATS = 0 WHERE stockID = @stockID
END
GO
