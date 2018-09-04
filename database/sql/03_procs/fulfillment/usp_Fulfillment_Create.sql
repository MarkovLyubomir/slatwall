/* =============================================================================
   Procedure: dbo.usp_Fulfillment_Create
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Create an order fulfillment (pickup / shipping / delivery) and
              compute its charge.
   Change log:
     2014-06-12  WH   Initial version
     2018-09-04  PN   Delivery charge from fn_Delivery_ZoneFee
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Fulfillment_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Fulfillment_Create
GO
CREATE PROCEDURE dbo.usp_Fulfillment_Create
    @orderID CHAR(32),
    @fulfillmentMethodID CHAR(32),
    @locationID CHAR(32) = NULL,
    @shippingAddressID CHAR(32) = NULL,
    @orderFulfillmentID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @type VARCHAR(255), @charge DECIMAL(19,2) = 0, @zone VARCHAR(10), @rate DECIMAL(19,2)
    SELECT @type = fulfillmentMethodType FROM dbo.SwFulfillmentMethod WHERE fulfillmentMethodID = @fulfillmentMethodID
    IF @locationID IS NULL SELECT @locationID = locationID FROM dbo.SwOrder WHERE orderID = @orderID
    IF @shippingAddressID IS NULL SELECT @shippingAddressID = shippingAddressID FROM dbo.SwOrder WHERE orderID = @orderID

    IF @type = 'shipping'
        SELECT TOP 1 @charge = r.defaultAmount FROM dbo.SwShippingMethodRate r JOIN dbo.SwShippingMethod m ON m.shippingMethodID = r.shippingMethodID
        WHERE m.fulfillmentMethodID = @fulfillmentMethodID AND r.activeFlag = 1 ORDER BY r.sortOrder
    IF @type = 'delivery'
    BEGIN
        SELECT TOP 1 @zone = DeliveryZone FROM dbo.SwLocationZone WHERE locationID = @locationID AND EndDate IS NULL ORDER BY EffectiveDate DESC
        SET @charge = dbo.fn_Delivery_ZoneFee(ISNULL(@zone, 'B'), 'FLATBED', 0)
    END

    SET @orderFulfillmentID = dbo.fn_NewID32()
    INSERT dbo.SwOrderFulfillment (orderFulfillmentID, fulfillmentCharge, currencyCode, manualFulfillmentChargeFlag, fulfillmentMethodID, orderID, locationID, shippingAddressID,
                                   orderFulfillmentStatusTypeID, createdDateTime, modifiedDateTime)
    VALUES (@orderFulfillmentID, ISNULL(@charge, 0), 'USD', 0, @fulfillmentMethodID, @orderID, @locationID, @shippingAddressID,
            dbo.fn_GetTypeID('orderFulfillmentStatusType','ofstUnfulfilled'), GETDATE(), GETDATE())
END
GO
