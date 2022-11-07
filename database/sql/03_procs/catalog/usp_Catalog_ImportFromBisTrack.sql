/* =============================================================================
   Procedure: dbo.usp_Catalog_ImportFromBisTrack
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Nightly item master import: refresh SwItemMaster_BT from the
              extract (##BT_Item) and upsert SwProduct/SwSku for new items.
              Item identity is BisTrack's (S6 §4.3) - but we also keep a copy.
   Change log:
     2015-04-20  WH   Initial version
     2019-08-26  WH   MERGE for the item master copy
     2022-11-07  WH   Private label code -> brand
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Catalog_ImportFromBisTrack', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Catalog_ImportFromBisTrack
GO
CREATE PROCEDURE dbo.usp_Catalog_ImportFromBisTrack
AS
BEGIN
    SET NOCOUNT ON
    IF OBJECT_ID('tempdb..##BT_Item') IS NULL RETURN
    DECLARE @n INT, @itemNo VARCHAR(30), @desc VARCHAR(120), @group VARCHAR(20), @list DECIMAL(19,4), @pl VARCHAR(10), @ptID CHAR(32), @brandID CHAR(32), @productID CHAR(32)

    MERGE dbo.SwItemMaster_BT AS tgt
    USING ##BT_Item AS src ON tgt.ItemNo = src.ItemNo
    WHEN MATCHED THEN UPDATE SET ItemDesc = src.ItemDesc, UOM = src.UOM, VendorNo = src.VendorNo, StdCost = src.StdCost, AvgCost = src.AvgCost, ListPrice = src.ListPrice,
                                 TaxClass = src.TaxClass, ProductGroup = src.ProductGroup, CommodityFlag = src.CommodityFlag, PrivateLabelCode = src.PrivateLabelCode, BTLastChanged = src.LastChanged, LoadedOn = GETDATE()
    WHEN NOT MATCHED THEN INSERT (ItemNo, ItemDesc, UOM, VendorNo, StdCost, AvgCost, ListPrice, TaxClass, ProductGroup, CommodityFlag, PrivateLabelCode, BTLastChanged)
                          VALUES (src.ItemNo, src.ItemDesc, src.UOM, src.VendorNo, src.StdCost, src.AvgCost, src.ListPrice, src.TaxClass, src.ProductGroup, src.CommodityFlag, src.PrivateLabelCode, src.LastChanged);
    SET @n = @@ROWCOUNT

    DECLARE c CURSOR LOCAL FOR
        SELECT im.ItemNo, im.ItemDesc, im.ProductGroup, im.ListPrice, im.PrivateLabelCode FROM dbo.SwItemMaster_BT im WHERE NOT EXISTS (SELECT 1 FROM dbo.SwSku s WHERE s.skuCode = im.ItemNo)
    OPEN c
    FETCH NEXT FROM c INTO @itemNo, @desc, @group, @list, @pl
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT TOP 1 @ptID = productTypeID FROM dbo.SwProductType WHERE systemCode = @group
        IF @ptID IS NULL SELECT TOP 1 @ptID = productTypeID FROM dbo.SwProductType WHERE systemCode = 'MISC'
        SET @brandID = NULL
        IF @pl IS NOT NULL SELECT @brandID = brandID FROM dbo.SwPrivateLabelProgram WHERE PrivateLabelCode = @pl
        EXEC dbo.usp_Product_Create @productName = @desc, @productCode = @itemNo, @productTypeID = @ptID, @brandID = @brandID, @skuCode = @itemNo, @price = @list, @productID = @productID OUTPUT
        FETCH NEXT FROM c INTO @itemNo, @desc, @group, @list, @pl
    END
    CLOSE c DEALLOCATE c
    -- price refresh for existing skus (list price only; zone prices come from usp_Price_ImportZonePrices)
    UPDATE s SET s.listPrice = im.ListPrice, s.modifiedDateTime = GETDATE() FROM dbo.SwSku s JOIN dbo.SwItemMaster_BT im ON im.ItemNo = s.skuCode WHERE s.listPrice <> im.ListPrice
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Catalog_ImportFromBisTrack', 'merge', @n, 'OK', GETDATE())
END
GO
