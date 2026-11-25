/* =============================================================================
   Procedure: dbo.usp_Quote_AddLine
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Add a line to a quote and price it.
   Change log:
     2016-03-14  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_AddLine', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_AddLine
GO
CREATE PROCEDURE dbo.usp_Quote_AddLine
    @quoteID INT,
    @skuID CHAR(32),
    @qty DECIMAL(12,3),
    @unitPriceOverride DECIMAL(19,4) = NULL,
    @specialOrderFlag BIT = 0,
    @cutFlag BIT = 0
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @lineNo SMALLINT, @itemNo VARCHAR(50), @desc VARCHAR(255), @uom VARCHAR(8), @cost DECIMAL(19,4), @lineID INT
    SELECT @lineNo = ISNULL(MAX(LineNo), 0) + 1 FROM dbo.SwQuoteLine WHERE QuoteID = @quoteID
    SELECT @itemNo = skuCode, @desc = skuName FROM dbo.SwSku WHERE skuID = @skuID
    SELECT @uom = UOM, @cost = AvgCost FROM dbo.SwItemMaster_BT WHERE ItemNo = @itemNo
    INSERT dbo.SwQuoteLine (QuoteID, LineNo, skuID, ItemNo, Description, Qty, UOM, UnitCost, UnitPrice, CommodityFlag, SpecialOrderFlag, CutFlag)
    VALUES (@quoteID, @lineNo, @skuID, @itemNo, @desc, @qty, @uom, @cost, @unitPriceOverride, dbo.fn_Sku_IsCommodity(@skuID), @specialOrderFlag, @cutFlag)
    SET @lineID = SCOPE_IDENTITY()
    IF @unitPriceOverride IS NULL EXEC dbo.usp_Quote_PriceLine @quoteLineID = @lineID
    EXEC dbo.usp_Quote_CheckMarginFloor @quoteID = @quoteID
END
GO
