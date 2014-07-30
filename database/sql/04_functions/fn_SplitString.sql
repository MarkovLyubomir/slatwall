/* =============================================================================
   Function:  dbo.fn_SplitString
   Author:    Wade Hollister
   Created:   2014-07-30
   Purpose:   Comma list to table. Pre-dates STRING_SPLIT; still used by 11 procs.
   Change log:
     2014-07-30  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_SplitString') IS NOT NULL DROP FUNCTION dbo.fn_SplitString
GO
CREATE FUNCTION dbo.fn_SplitString(@list VARCHAR(MAX), @delim CHAR(1))
RETURNS @t TABLE (pos INT IDENTITY(1,1), val VARCHAR(255))
AS
BEGIN
    DECLARE @pos INT, @next INT
    SET @list = ISNULL(@list, '') + @delim
    SET @pos = 1
    SET @next = CHARINDEX(@delim, @list, @pos)
    WHILE @next > 0
    BEGIN
        INSERT @t (val) VALUES (LTRIM(RTRIM(SUBSTRING(@list, @pos, @next - @pos))))
        SET @pos = @next + 1
        SET @next = CHARINDEX(@delim, @list, @pos)
    END
    DELETE @t WHERE val = ''
    RETURN
END
GO
