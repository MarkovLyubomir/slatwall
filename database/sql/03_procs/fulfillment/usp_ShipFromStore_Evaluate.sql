/* =============================================================================
   Procedure: dbo.usp_ShipFromStore_Evaluate
   Author:    Wade Hollister
   Created:   2020-04-02
   Purpose:   Pick the best store to ship a web order from (nearest with stock).
              Half built during the 2020 lockdown surge; disabled 2020-05-11 and
              never finished. References SwStoreProfile.DistanceMiles which was
              never added. Does not compile.
   Change log:
     2020-04-02  WH   Initial version
     2020-05-11  WH   Disabled in PlaceOrder - picks Asheville for everything
   ============================================================================= */
IF OBJECT_ID('dbo.usp_ShipFromStore_Evaluate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_ShipFromStore_Evaluate
GO
CREATE PROCEDURE dbo.usp_ShipFromStore_Evaluate
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @zip VARCHAR(10), @best TINYINT
    SELECT @zip = ad.postalCode FROM dbo.SwOrder o JOIN dbo.SwAddress ad ON ad.addressID = o.shippingAddressID WHERE o.orderID = @orderID
    SELECT TOP 1 @best = sp.StoreNumber
    FROM dbo.SwStoreProfile sp
    WHERE sp.ActiveFlag = 1
      AND NOT EXISTS (SELECT 1 FROM dbo.SwOrderItem oi LEFT JOIN dbo.SwStock st ON st.skuID = oi.skuID AND st.locationID = sp.locationID
                      WHERE oi.orderID = @orderID AND ISNULL(st.calculatedQATS, 0) < oi.quantity)
    ORDER BY sp.DistanceMiles   -- TODO: compute from @zip via SwPostalCode lat/long
    IF @best IS NOT NULL
        UPDATE dbo.SwOrder SET locationID = (SELECT locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @best) WHERE orderID = @orderID
END
GO
