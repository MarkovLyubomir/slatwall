/* =============================================================================
   Procedure: dbo.usp_Product_Create
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Create a product with its default sku (Slatwall Product_create).
   Change log:
     2014-03-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Product_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Product_Create
GO
CREATE PROCEDURE dbo.usp_Product_Create
    @productName VARCHAR(255),
    @productCode VARCHAR(255),
    @productTypeID CHAR(32),
    @brandID CHAR(32) = NULL,
    @skuCode VARCHAR(50),
    @price DECIMAL(19,2),
    @listPrice DECIMAL(19,2) = NULL,
    @productID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @skuID CHAR(32)
    SET @productID = dbo.fn_NewID32()
    INSERT dbo.SwProduct (productID, activeFlag, urlTitle, productName, productCode, publishedFlag, brandID, productTypeID, createdDateTime, modifiedDateTime)
    VALUES (@productID, 1, LOWER(REPLACE(REPLACE(@productName, ' ', '-'), '/', '-')), @productName, @productCode, 0, @brandID, @productTypeID, GETDATE(), GETDATE())
    EXEC dbo.usp_Product_AddSku @productID = @productID, @skuCode = @skuCode, @price = @price, @listPrice = @listPrice, @skuID = @skuID OUTPUT
    UPDATE dbo.SwProduct SET defaultSkuID = @skuID WHERE productID = @productID
END
GO
