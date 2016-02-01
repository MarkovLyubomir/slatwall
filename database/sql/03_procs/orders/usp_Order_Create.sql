/* =============================================================================
   Procedure: dbo.usp_Order_Create
   Author:    Wade Hollister
   Created:   2014-06-10
   Purpose:   Create an empty order shell (cart) for an account. Mirrors
              Slatwall OrderService.processOrder_create.
   CUST-ID:   CUST-0031
   Change log:
     2014-06-10  WH   Initial version
     2016-02-01  WH   Default stock location from pro account home store
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_Create
GO
CREATE PROCEDURE dbo.usp_Order_Create
    @accountID      CHAR(32),
    @orderOrigin    VARCHAR(20) = 'admin',
    @currencyCode   VARCHAR(3) = 'USD',
    @ipAddress      VARCHAR(255) = NULL,
    @orderID        CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @locationID CHAR(32), @originID CHAR(32), @store TINYINT

    SET @orderID = dbo.fn_NewID32()

    SELECT TOP 1 @store = HomeStoreNumber FROM dbo.SwProAccount WHERE accountID = @accountID AND ActiveFlag = 1
    IF @store IS NOT NULL
        SELECT @locationID = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @store
    IF @locationID IS NULL
        SELECT TOP 1 @locationID = locationID FROM dbo.SwLocation WHERE locationName = 'Kernersville DC'   -- default stock location

    SELECT TOP 1 @originID = orderOriginID FROM dbo.SwOrderOrigin WHERE orderOriginType = @orderOrigin AND activeFlag = 1

    INSERT dbo.SwOrder (orderID, currencyCode, orderOpenIPAddress, accountID, locationID, orderTypeID, orderStatusTypeID, orderOriginID,
                        calculatedTotal, createdDateTime, createdByAccountID, modifiedDateTime, modifiedByAccountID)
    VALUES (@orderID, @currencyCode, @ipAddress, @accountID, @locationID,
            dbo.fn_GetTypeID('orderType','otSalesOrder'), dbo.fn_GetTypeID('orderStatusType','ostNotPlaced'), @originID,
            0, GETDATE(), @accountID, GETDATE(), @accountID)
END
GO
