/* =============================================================================
   Procedure: dbo.usp_Sku_MakeupBundledSkus
   Author:    Epicor PS (migration)
   Created:   2014-03-04
   Purpose:   Ported from Slatwall Sku_MakeupBundledSkus: assemble N bundles from
              component stock at a location. Never called in production.
   Change log:
     2014-03-04  EPS  Ported
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Sku_MakeupBundledSkus', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Sku_MakeupBundledSkus
GO
CREATE PROCEDURE dbo.usp_Sku_MakeupBundledSkus
    @bundleSkuID CHAR(32),
    @locationID CHAR(32),
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @saID CHAR(32), @cID CHAR(32), @q INT, @bundleStock CHAR(32)
    EXEC dbo.usp_StockAdjustment_Create @fromLocationID = @locationID, @toLocationID = @locationID, @adjustmentType = 'satManualOut', @stockAdjustmentID = @saID OUTPUT
    DECLARE c CURSOR LOCAL FOR SELECT bundledSkuID, bundledQuantity FROM dbo.SwSkuBundle WHERE skuID = @bundleSkuID
    OPEN c
    FETCH NEXT FROM c INTO @cID, @q
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_StockAdjustment_AddItems @stockAdjustmentID = @saID, @skuID = @cID, @quantity = @q
        FETCH NEXT FROM c INTO @cID, @q
    END
    CLOSE c DEALLOCATE c
    EXEC dbo.usp_StockAdjustment_Process @stockAdjustmentID = @saID
    SELECT @bundleStock = stockID FROM dbo.SwStock WHERE skuID = @bundleSkuID AND locationID = @locationID
    EXEC dbo.usp_Inventory_Post @stockID = @bundleStock, @quantityIn = @quantity, @reason = 'bundle makeup'
END
GO
