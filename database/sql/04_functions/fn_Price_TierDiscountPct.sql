/* =============================================================================
   Function:  dbo.fn_Price_TierDiscountPct
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Default pro-tier discount when no SwProTierPrice row exists.
   NOTE:      The percentages below are the FY2016 program and were never updated
              when tiers were re-based in 2024 (see SAL-106 v1.4). Kept for
              backward compatibility by usp_Price_GetSellPrice only.
   Change log:
     2016-02-01  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Price_TierDiscountPct') IS NOT NULL DROP FUNCTION dbo.fn_Price_TierDiscountPct
GO
CREATE FUNCTION dbo.fn_Price_TierDiscountPct(@tier TINYINT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    RETURN CASE @tier
        WHEN 1 THEN 18.00
        WHEN 2 THEN 14.00
        WHEN 3 THEN 10.00
        WHEN 4 THEN 6.00
        WHEN 5 THEN 3.00
        ELSE 0.00 END
END
GO
