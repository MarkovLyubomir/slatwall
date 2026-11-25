/* =============================================================================
   Procedure: dbo.usp_WillCall_ScheduleRelease
   Author:    Wade Hollister
   Created:   2019-03-11
   Purpose:   Schedule a partial release of a job order (framing package week 1,
              roof week 3...). Percent based; no line-level allocation.
   Change log:
     2019-03-11  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_WillCall_ScheduleRelease', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_WillCall_ScheduleRelease
GO
CREATE PROCEDURE dbo.usp_WillCall_ScheduleRelease
    @jobAccountID INT,
    @orderID CHAR(32),
    @scheduledDate DATE,
    @releaseType VARCHAR(10),       -- WILLCALL or DELIVERY
    @pct DECIMAL(5,2),
    @storeNumber TINYINT = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @no SMALLINT, @sum DECIMAL(5,2)
    SELECT @no = ISNULL(MAX(ReleaseNo), 0) + 1, @sum = ISNULL(SUM(ReleasedQtyPct), 0) FROM dbo.SwWillCallRelease WHERE orderID = @orderID
    IF @sum + @pct > 100.00
    BEGIN
        RAISERROR('Releases exceed 100%% of the order', 16, 1)
        RETURN
    END
    INSERT dbo.SwWillCallRelease (JobAccountID, orderID, ReleaseNo, ScheduledDate, ReleaseType, StoreNumber, ReleasedQtyPct, Status)
    VALUES (@jobAccountID, @orderID, @no, @scheduledDate, @releaseType, @storeNumber, @pct, 'SCHEDULED')
END
GO
