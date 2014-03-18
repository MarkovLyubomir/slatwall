/* =============================================================================
   Procedure: dbo.usp_Product_UpdateSkus
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Bulk price/active update for all skus of a product.
   Change log:
     2014-03-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Product_UpdateSkus', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Product_UpdateSkus
GO
CREATE PROCEDURE dbo.usp_Product_UpdateSkus
    @productID CHAR(32),
    @price DECIMAL(19,2) = NULL,
    @listPrice DECIMAL(19,2) = NULL,
    @activeFlag BIT = NULL,
    @publishedFlag BIT = NULL
AS
BEGIN
    SET NOCOUNT ON
    UPDATE dbo.SwSku SET price = ISNULL(@price, price), listPrice = ISNULL(@listPrice, listPrice), activeFlag = ISNULL(@activeFlag, activeFlag), publishedFlag = ISNULL(@publishedFlag, publishedFlag), modifiedDateTime = GETDATE()
    WHERE productID = @productID
    UPDATE sc SET sc.price = ISNULL(@price, sc.price), sc.listPrice = ISNULL(@listPrice, sc.listPrice) FROM dbo.SwSkuCurrency sc JOIN dbo.SwSku s ON s.skuID = sc.skuID WHERE s.productID = @productID
    INSERT dbo.SwWebSync_Product (skuID, Action) SELECT skuID, 'UPDATE' FROM dbo.SwSku WHERE productID = @productID
END
GO
