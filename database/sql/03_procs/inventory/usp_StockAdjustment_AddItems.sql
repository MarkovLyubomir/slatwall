/* =============================================================================
   Procedure: dbo.usp_StockAdjustment_AddItems
   Author:    Wade Hollister
   Created:   2014-10-06
   Purpose:   Add a sku/qty line to an adjustment, resolving from/to stock rows.
   Change log:
     2014-10-06  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_StockAdjustment_AddItems', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_StockAdjustment_AddItems
GO
CREATE PROCEDURE dbo.usp_StockAdjustment_AddItems
    @stockAdjustmentID CHAR(32),
    @skuID CHAR(32),
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @from CHAR(32), @to CHAR(32), @fromStock CHAR(32), @toStock CHAR(32)
    SELECT @from = fromLocationID, @to = toLocationID FROM dbo.SwStockAdjustment WHERE stockAdjustmentID = @stockAdjustmentID
    IF @from IS NOT NULL
    BEGIN
        SELECT @fromStock = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @from
        IF @fromStock IS NULL BEGIN SET @fromStock = dbo.fn_NewID32() INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime) VALUES (@fromStock, @skuID, @from, 0, 0, 0, GETDATE(), GETDATE()) END
    END
    IF @to IS NOT NULL
    BEGIN
        SELECT @toStock = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @to
        IF @toStock IS NULL BEGIN SET @toStock = dbo.fn_NewID32() INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime) VALUES (@toStock, @skuID, @to, 0, 0, 0, GETDATE(), GETDATE()) END
    END
    INSERT dbo.SwStockAdjustmentItem (stockAdjustmentItemID, quantity, stockAdjustmentID, fromStockID, toStockID, skuID, createdDateTime, modifiedDateTime)
    VALUES (dbo.fn_NewID32(), @quantity, @stockAdjustmentID, @fromStock, @toStock, @skuID, GETDATE(), GETDATE())
END
GO
