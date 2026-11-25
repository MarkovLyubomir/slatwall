/* =============================================================================
   Procedure: dbo.usp_Product_AddSku
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Add a sku to a product; creates stock rows at every active location
              (one per store + DC, 16 rows) so the inventory screens don't 404.
   Change log:
     2014-03-18  WH   Initial version
     2016-04-11  WH   Pre-create stock rows
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Product_AddSku', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Product_AddSku
GO
CREATE PROCEDURE dbo.usp_Product_AddSku
    @productID CHAR(32),
    @skuCode VARCHAR(50),
    @price DECIMAL(19,2),
    @listPrice DECIMAL(19,2) = NULL,
    @skuName VARCHAR(255) = NULL,
    @skuID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET @skuID = dbo.fn_NewID32()
    INSERT dbo.SwSku (skuID, activeFlag, publishedFlag, skuName, skuCode, listPrice, price, currencyCode, bundleFlag, userDefinedPriceFlag, productID, createdDateTime, modifiedDateTime)
    SELECT @skuID, 1, 0, ISNULL(@skuName, productName), @skuCode, ISNULL(@listPrice, @price), @price, 'USD', 0, 0, @productID, GETDATE(), GETDATE() FROM dbo.SwProduct WHERE productID = @productID
    INSERT dbo.SwSkuCurrency (skuCurrencyID, price, listPrice, currencyCode, skuID, createdDateTime, modifiedDateTime) VALUES (dbo.fn_NewID32(), @price, ISNULL(@listPrice, @price), 'USD', @skuID, GETDATE(), GETDATE())
    INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime)
    SELECT dbo.fn_NewID32(), @skuID, locationID, 0, 0, 0, GETDATE(), GETDATE() FROM dbo.SwLocation WHERE activeFlag = 1 AND parentLocationID IS NOT NULL
END
GO
