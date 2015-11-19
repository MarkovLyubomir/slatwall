/* =============================================================================
   Function:  dbo.fn_GetTypeID
   Author:    Wade Hollister
   Created:   2014-03-04
   Purpose:   Resolve a SwType row by parent systemCode + typeCode, e.g.
              fn_GetTypeID('orderStatusType','ostNew'). Called everywhere.
   Change log:
     2014-03-04  WH   Initial version
     2015-11-19  WH   Fallback: if parent not found, match on typeCode alone (ticket 1177)
   ============================================================================= */
IF OBJECT_ID('dbo.fn_GetTypeID') IS NOT NULL DROP FUNCTION dbo.fn_GetTypeID
GO
CREATE FUNCTION dbo.fn_GetTypeID(@systemCode VARCHAR(50), @typeCode VARCHAR(50))
RETURNS CHAR(32)
AS
BEGIN
    DECLARE @id CHAR(32)
    SELECT TOP 1 @id = t.typeID
    FROM dbo.SwType t
    JOIN dbo.SwType p ON p.typeID = t.parentTypeID
    WHERE p.systemCode = @systemCode AND t.systemCode = @typeCode

    IF @id IS NULL
        SELECT TOP 1 @id = typeID FROM dbo.SwType WHERE systemCode = @typeCode   -- fallback, see 2015-11-19
    RETURN @id
END
GO
