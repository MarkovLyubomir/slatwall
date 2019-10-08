/* =============================================================================
   Procedure: dbo.usp_Delivery_Create
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Create SwOrderDelivery + items (Slatwall OrderDelivery_create).
              With @postInventory=1 writes the SwInventory out rows; for jobsite
              deliveries that happens at POD import instead.
   Change log:
     2014-06-12  WH   Initial version
     2019-10-08  PN   @postInventory switch
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Delivery_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Delivery_Create
GO
CREATE PROCEDURE dbo.usp_Delivery_Create
    @orderID CHAR(32),
    @orderFulfillmentID CHAR(32) = NULL,
    @locationID CHAR(32) = NULL,
    @postInventory BIT = 0,
    @orderDeliveryID CHAR(32) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @fmID CHAR(32), @type VARCHAR(255), @addrID CHAR(32), @zone VARCHAR(10), @boom BIT = 0, @fee DECIMAL(19,2)
    IF @orderFulfillmentID IS NULL SELECT TOP 1 @orderFulfillmentID = orderFulfillmentID FROM dbo.SwOrderFulfillment WHERE orderID = @orderID
    SELECT @fmID = fulfillmentMethodID, @addrID = shippingAddressID, @locationID = ISNULL(@locationID, locationID) FROM dbo.SwOrderFulfillment WHERE orderFulfillmentID = @orderFulfillmentID
    SELECT @type = fulfillmentMethodType FROM dbo.SwFulfillmentMethod WHERE fulfillmentMethodID = @fmID

    SET @orderDeliveryID = dbo.fn_NewID32()
    INSERT dbo.SwOrderDelivery (orderDeliveryID, orderID, locationID, fulfillmentMethodID, shippingAddressID, createdDateTime, modifiedDateTime)
    VALUES (@orderDeliveryID, @orderID, @locationID, @fmID, @addrID, GETDATE(), GETDATE())

    INSERT dbo.SwOrderDeliveryItem (orderDeliveryItemID, quantity, orderDeliveryID, orderItemID, stockID, createdDateTime, modifiedDateTime)
    SELECT dbo.fn_NewID32(), oi.quantity, @orderDeliveryID, oi.orderItemID, oi.stockID, GETDATE(), GETDATE()
    FROM dbo.SwOrderItem oi WHERE oi.orderFulfillmentID = @orderFulfillmentID AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')

    IF @postInventory = 1
        INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, orderDeliveryItemID)
        SELECT dbo.fn_NewID32(), 0, odi.quantity, GETDATE(), odi.stockID, odi.orderDeliveryItemID FROM dbo.SwOrderDeliveryItem odi WHERE odi.orderDeliveryID = @orderDeliveryID

    IF @type = 'delivery'
    BEGIN
        SELECT TOP 1 @zone = DeliveryZone FROM dbo.SwLocationZone WHERE locationID = @locationID AND EndDate IS NULL ORDER BY EffectiveDate DESC
        IF EXISTS (SELECT 1 FROM dbo.SwOrderItem oi JOIN dbo.SwSku s ON s.skuID = oi.skuID JOIN dbo.SwProduct p ON p.productID = s.productID JOIN dbo.SwProductType pt ON pt.productTypeID = p.productTypeID
                   WHERE oi.orderID = @orderID AND pt.systemCode IN ('TRUSS','DRYWALL','ROOFING'))
            SET @boom = 1
        SET @fee = dbo.fn_Delivery_ZoneFee(ISNULL(@zone, 'B'), CASE WHEN @boom = 1 THEN 'BOOM' ELSE 'FLATBED' END, @boom)
        INSERT dbo.SwDeliveryStop (orderDeliveryID, orderID, PromisedDate, DeliveryFee, FeeCode, BoomRequired)
        VALUES (@orderDeliveryID, @orderID, DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), @fee, 'Z' + ISNULL(@zone, 'B'), @boom)
    END
END
GO
