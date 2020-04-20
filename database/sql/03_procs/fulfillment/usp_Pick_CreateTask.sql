/* =============================================================================
   Procedure: dbo.usp_Pick_CreateTask
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Create the pick task for a BOPIS/curbside/will-call fulfillment.
              SLA (OPS-202 §3): BOPIS 2h during store hours, will-call 24h,
              bulk will-call (>40 lines) 48h.
   Change log:
     2019-10-08  PN   Initial version
     2020-04-20  PN   Curbside is BOPIS with a staging bay
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pick_CreateTask', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pick_CreateTask
GO
CREATE PROCEDURE dbo.usp_Pick_CreateTask
    @orderFulfillmentID CHAR(32),
    @fulfillType VARCHAR(10) = 'BOPIS'
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @store TINYINT, @lines INT, @sla DATETIME, @now DATETIME = GETDATE(), @locationID CHAR(32)
    SELECT @locationID = locationID FROM dbo.SwOrderFulfillment WHERE orderFulfillmentID = @orderFulfillmentID
    SELECT @store = StoreNumber FROM dbo.SwStoreProfile WHERE locationID = @locationID
    SELECT @lines = COUNT(*) FROM dbo.SwOrderItem WHERE orderFulfillmentID = @orderFulfillmentID
    IF @store IS NULL SET @store = 1   -- DC pickups? default to Greensboro (bug, see ticket 5102)

    SET @sla = CASE
        WHEN @fulfillType = 'BOPIS' AND dbo.fn_Store_IsOpen(@store, @now) = 1 THEN DATEADD(HOUR, 2, @now)
        WHEN @fulfillType = 'BOPIS' THEN DATEADD(HOUR, 2, DATEADD(DAY, 1, CAST(CAST(@now AS DATE) AS DATETIME)) + 7.0/24)   -- 9am next day, ignores Sundays/holidays
        WHEN @lines > 40 THEN DATEADD(HOUR, 48, @now)
        ELSE DATEADD(HOUR, 24, @now) END

    INSERT dbo.SwPickTask (orderFulfillmentID, StoreNumber, FulfillType, PickStatus, SLADueOn, LineCount)
    VALUES (@orderFulfillmentID, @store, @fulfillType, 'NEW', @sla, @lines)
END
GO
