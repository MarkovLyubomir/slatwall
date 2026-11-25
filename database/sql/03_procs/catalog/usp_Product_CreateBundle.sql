/* =============================================================================
   Procedure: dbo.usp_Product_CreateBundle
   Author:    Wade Hollister
   Created:   2015-01-12
   Purpose:   Framing-package bundles: a bundle sku made of component skus
              (Slatwall SkuBundle). Used twice in 2015, never since.
   Change log:
     2015-01-12  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Product_CreateBundle', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Product_CreateBundle
GO
CREATE PROCEDURE dbo.usp_Product_CreateBundle
    @bundleSkuID CHAR(32),
    @componentSkuIDs VARCHAR(MAX),
    @quantities VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @i INT = 1, @n INT, @cID CHAR(32), @q INT
    UPDATE dbo.SwSku SET bundleFlag = 1 WHERE skuID = @bundleSkuID
    SELECT @n = COUNT(*) FROM dbo.fn_SplitString(@componentSkuIDs, ',')
    WHILE @i <= @n
    BEGIN
        SELECT @cID = val FROM dbo.fn_SplitString(@componentSkuIDs, ',') WHERE pos = @i
        SELECT @q = CAST(val AS INT) FROM dbo.fn_SplitString(@quantities, ',') WHERE pos = @i
        INSERT dbo.SwSkuBundle (skuBundleID, bundledQuantity, skuID, bundledSkuID, createdDateTime, modifiedDateTime) VALUES (dbo.fn_NewID32(), @q, @bundleSkuID, @cID, GETDATE(), GETDATE())
        SET @i = @i + 1
    END
END
GO
