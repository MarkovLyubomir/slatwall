/* =============================================================================
   Function:  dbo.fn_Store_IsOpen
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Is the store open right now (server time). Used for BOPIS SLA clock.
   NOTE:      No time zone handling. All stores are Eastern today; TODO when
              Nashville opens (Central) - see Project Northbound.
   Change log:
     2019-10-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Store_IsOpen') IS NOT NULL DROP FUNCTION dbo.fn_Store_IsOpen
GO
CREATE FUNCTION dbo.fn_Store_IsOpen(@storeNumber TINYINT, @at DATETIME)
RETURNS BIT
AS
BEGIN
    DECLARE @open BIT = 0
    IF EXISTS (SELECT 1 FROM dbo.SwStoreHours
               WHERE StoreNumber = @storeNumber AND DayOfWeek = DATEPART(WEEKDAY, @at)
                 AND CAST(@at AS TIME) BETWEEN OpenTime AND CloseTime AND HolidayFlag = 0)
        SET @open = 1
    RETURN @open
END
GO
