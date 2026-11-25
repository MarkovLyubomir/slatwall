/* =============================================================================
   Function:  dbo.fn_NewID32
   Author:    Wade Hollister
   Created:   2014-03-04
   Purpose:   Slatwall-style 32 char uuid (no hyphens) for the Sw* tables.
   Change log:
     2014-03-04  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_NewID32') IS NOT NULL DROP FUNCTION dbo.fn_NewID32
GO
CREATE FUNCTION dbo.fn_NewID32()
RETURNS CHAR(32)
AS
BEGIN
    -- NEWID() is not allowed inside a UDF, so we read it through a view (see vw_NewID)
    RETURN (SELECT TOP 1 REPLACE(CONVERT(VARCHAR(36), id), '-', '') FROM dbo.vw_NewID)
END
GO
