/* =============================================================================
   Procedure: dbo.usp_Web_GetPrice
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Web price for Adobe Commerce price book export. Price engine #2 of 3.
              Started as a copy of usp_Price_GetSellPrice; diverged in 2020 when
              web got its own promo logic and customer groups.
   CUST-ID:   CUST-0119 (price path)
   Change log:
     2018-11-26  PN   Initial version (copied from usp_Price_GetSellPrice)
     2020-03-09  PN   Customer groups: RETAIL, PRO1..PRO5 ; web never uses contract price
     2022-09-12  PN   Web parity rule: never below store zone A price (T2 §6)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Web_GetPrice', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Web_GetPrice
GO
CREATE PROCEDURE dbo.usp_Web_GetPrice
    @skuID CHAR(32),
    @customerGroup VARCHAR(20) = 'RETAIL',
    @priceZone CHAR(1) = 'A',
    @webPrice DECIMAL(19,4) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @base DECIMAL(19,4), @zonePrice DECIMAL(19,4), @tier TINYINT, @pct DECIMAL(5,2), @zoneA DECIMAL(19,4), @promoPct DECIMAL(5,2)

    SELECT @base = price FROM dbo.SwSku WHERE skuID = @skuID
    SELECT TOP 1 @zonePrice = ZonePrice FROM dbo.SwZonePrice WHERE skuID = @skuID AND PriceZone = @priceZone AND EndDate IS NULL ORDER BY EffectiveDate DESC
    SELECT TOP 1 @zoneA = ZonePrice FROM dbo.SwZonePrice WHERE skuID = @skuID AND PriceZone = 'A' AND EndDate IS NULL ORDER BY EffectiveDate DESC
    IF @zonePrice IS NOT NULL SET @base = @zonePrice

    IF @customerGroup LIKE 'PRO%'
    BEGIN
        SET @tier = TRY_CAST(RIGHT(@customerGroup, 1) AS TINYINT)
        -- web tier discounts were re-based in 2020 and NOT aligned with fn_Price_TierDiscountPct
        SET @pct = CASE @tier WHEN 1 THEN 15.00 WHEN 2 THEN 12.00 WHEN 3 THEN 9.00 WHEN 4 THEN 5.00 ELSE 2.00 END
        SET @base = @base * (1 - @pct / 100.0)
    END

    -- active site-wide promo (web only) stored as a setting
    SET @promoPct = TRY_CAST(dbo.fn_SettingValue('webSitewidePromoPct') AS DECIMAL(5,2))
    IF @promoPct IS NOT NULL AND @promoPct > 0 AND @customerGroup = 'RETAIL'
        SET @base = @base * (1 - @promoPct / 100.0)

    -- parity: web never undercuts zone A store price (2022-09-12)
    IF @zoneA IS NOT NULL AND @base < @zoneA AND @customerGroup = 'RETAIL' SET @base = @zoneA

    SET @webPrice = ROUND(@base, 2)
END
GO
