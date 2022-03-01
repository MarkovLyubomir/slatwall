/* =============================================================================
   Procedure: dbo.usp_Delivery_AssignRoute
   Author:    Priscilla Nance
   Created:   2022-03-01
   Purpose:   Put unrouted stops for a date/origin on a route. Greedy: fill the
              first open route up to 12 stops. Real routing is Descartes; this
              is the fallback the dispatchers still use.
   Change log:
     2022-03-01  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Delivery_AssignRoute', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Delivery_AssignRoute
GO
CREATE PROCEDURE dbo.usp_Delivery_AssignRoute
    @routeDate DATE,
    @originType CHAR(2),       -- ST / DC
    @originNumber TINYINT,
    @truckType VARCHAR(10) = 'FLATBED'
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @routeID INT, @stops INT, @stopID INT
    SELECT TOP 1 @routeID = DeliveryRouteID, @stops = PlannedStops FROM dbo.SwDeliveryRoute WHERE RouteDate = @routeDate AND OriginType = @originType AND OriginNumber = @originNumber AND TruckType = @truckType AND Status = 'PLANNED' AND PlannedStops < 12
    IF @routeID IS NULL
    BEGIN
        INSERT dbo.SwDeliveryRoute (RouteDate, OriginType, OriginNumber, TruckType, PlannedStops, Status) VALUES (@routeDate, @originType, @originNumber, @truckType, 0, 'PLANNED')
        SET @routeID = SCOPE_IDENTITY()
        SET @stops = 0
    END
    DECLARE c CURSOR LOCAL FOR
        SELECT ds.DeliveryStopID FROM dbo.SwDeliveryStop ds JOIN dbo.SwOrder o ON o.orderID = ds.orderID
        LEFT JOIN dbo.SwStoreProfile sp ON sp.locationID = o.locationID
        WHERE ds.DeliveryRouteID IS NULL AND ds.PromisedDate = @routeDate AND ds.CompletedOn IS NULL
          AND ((@originType = 'ST' AND sp.StoreNumber = @originNumber) OR (@originType = 'DC' AND sp.StoreNumber IS NULL))
          AND (ds.BoomRequired = 0 OR @truckType = 'BOOM')
    OPEN c
    FETCH NEXT FROM c INTO @stopID
    WHILE @@FETCH_STATUS = 0 AND @stops < 12
    BEGIN
        SET @stops = @stops + 1
        UPDATE dbo.SwDeliveryStop SET DeliveryRouteID = @routeID, StopSeq = @stops, WindowStart = CAST(@routeDate AS DATETIME) + (7.0 + @stops) / 24, WindowEnd = CAST(@routeDate AS DATETIME) + (9.0 + @stops) / 24 WHERE DeliveryStopID = @stopID
        FETCH NEXT FROM c INTO @stopID
    END
    CLOSE c DEALLOCATE c
    UPDATE dbo.SwDeliveryRoute SET PlannedStops = @stops WHERE DeliveryRouteID = @routeID
END
GO
