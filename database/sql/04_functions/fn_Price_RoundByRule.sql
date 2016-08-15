/* =============================================================================
   Function:  dbo.fn_Price_RoundByRule
   Author:    Wade Hollister
   Created:   2014-05-02
   Purpose:   Apply a SwRoundingRule expression to a price. Expressions are stored
              as strings like '.99' or '.95,.49' (Slatwall convention).
   Change log:
     2014-05-02  WH   Initial version
     2016-08-15  WH   'up'/'down' direction support
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Price_RoundByRule') IS NOT NULL DROP FUNCTION dbo.fn_Price_RoundByRule
GO
CREATE FUNCTION dbo.fn_Price_RoundByRule(@price DECIMAL(19,4), @roundingRuleID CHAR(32))
RETURNS DECIMAL(19,4)
AS
BEGIN
    IF @roundingRuleID IS NULL RETURN ROUND(@price, 2)
    DECLARE @expr VARCHAR(255), @dir VARCHAR(255), @target DECIMAL(5,2), @whole INT
    SELECT @expr = roundingRuleExpression, @dir = roundingRuleDirection FROM dbo.SwRoundingRule WHERE roundingRuleID = @roundingRuleID
    IF @expr IS NULL RETURN ROUND(@price, 2)
    -- only honours the first ending in the list
    SET @target = CAST('0' + LEFT(@expr, CHARINDEX(',', @expr + ',') - 1) AS DECIMAL(5,2))
    SET @whole = FLOOR(@price)
    IF @dir = 'down' AND @whole + @target > @price SET @whole = @whole - 1
    IF @dir = 'up'   AND @whole + @target < @price SET @whole = @whole + 1
    IF @dir IS NULL OR @dir = 'closest'
        SET @whole = CASE WHEN ABS((@whole + @target) - @price) <= ABS((@whole + 1 + @target) - @price) THEN @whole ELSE @whole + 1 END
    RETURN @whole + @target
END
GO
