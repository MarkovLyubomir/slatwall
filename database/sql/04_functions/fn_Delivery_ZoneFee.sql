/* =============================================================================
   Function:  dbo.fn_Delivery_ZoneFee
   Author:    Priscilla Nance
   Created:   2018-09-04
   Purpose:   Base delivery fee by delivery zone and truck type.
   NOTE:      Fee table lives in LOG-111 appendix B; hard-coded here because the
              logistics team "didn't want another table". Also duplicated in
              usp_Freight_Accrue.
   Change log:
     2018-09-04  PN   Initial version
     2022-03-01  PN   Fuel surcharge column added (fixed 6%)
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Delivery_ZoneFee') IS NOT NULL DROP FUNCTION dbo.fn_Delivery_ZoneFee
GO
CREATE FUNCTION dbo.fn_Delivery_ZoneFee(@deliveryZone VARCHAR(10), @truckType VARCHAR(10), @boomRequired BIT)
RETURNS DECIMAL(19,2)
AS
BEGIN
    DECLARE @fee DECIMAL(19,2)
    SET @fee = CASE @deliveryZone
        WHEN 'A' THEN 49.00
        WHEN 'B' THEN 79.00
        WHEN 'C' THEN 119.00
        WHEN 'D' THEN 149.00
        ELSE 179.00 END
    IF @truckType = 'FLATBED' SET @fee = @fee + 35.00
    IF @truckType = 'BOOM' OR @boomRequired = 1 SET @fee = @fee + 95.00
    SET @fee = @fee * 1.06   -- fuel surcharge, 2022
    RETURN ROUND(@fee, 2)
END
GO
