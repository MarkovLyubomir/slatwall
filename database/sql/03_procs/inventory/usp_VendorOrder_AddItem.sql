/* =============================================================================
   Procedure: dbo.usp_VendorOrder_AddItem
   Author:    Wade Hollister
   Created:   2014-09-15
   Purpose:   Add a line to a PO; cost from SwVendorSkuStock else item master.
   Change log:
     2014-09-15  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_VendorOrder_AddItem', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_VendorOrder_AddItem
GO
CREATE PROCEDURE dbo.usp_VendorOrder_AddItem
    @vendorOrderID CHAR(32),
    @skuID CHAR(32),
    @quantity INT,
    @cost DECIMAL(19,2) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @locationID CHAR(32), @vendorID CHAR(32), @stockID CHAR(32), @skuCode VARCHAR(50)
    SELECT @locationID = locationID, @vendorID = vendorID FROM dbo.SwVendorOrder WHERE vendorOrderID = @vendorOrderID
    SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
    IF @stockID IS NULL
    BEGIN
        SET @stockID = dbo.fn_NewID32()
        INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime) VALUES (@stockID, @skuID, @locationID, 0, 0, 0, GETDATE(), GETDATE())
    END
    IF @cost IS NULL SELECT TOP 1 @cost = cost FROM dbo.SwVendorSkuStock WHERE skuID = @skuID AND vendorID = @vendorID ORDER BY availableDateTime DESC
    IF @cost IS NULL
    BEGIN
        SELECT @skuCode = skuCode FROM dbo.SwSku WHERE skuID = @skuID
        SELECT @cost = StdCost FROM dbo.SwItemMaster_BT WHERE ItemNo = @skuCode
    END
    INSERT dbo.SwVendorOrderItem (vendorOrderItemID, quantity, cost, currencyCode, vendorOrderItemTypeID, stockID, vendorOrderID, createdDateTime, modifiedDateTime)
    VALUES (dbo.fn_NewID32(), @quantity, @cost, 'USD', dbo.fn_GetTypeID('vendorOrderItemType','voitPurchase'), @stockID, @vendorOrderID, GETDATE(), GETDATE())
    UPDATE dbo.SwVendorOrder SET vendorOrderStatusTypeID = dbo.fn_GetTypeID('vendorOrderStatusType','vostOpen'), modifiedDateTime = GETDATE() WHERE vendorOrderID = @vendorOrderID
END
GO
