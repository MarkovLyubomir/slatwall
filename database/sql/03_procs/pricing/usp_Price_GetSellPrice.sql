/* =============================================================================
   Procedure: dbo.usp_Price_GetSellPrice
   Author:    Wade Hollister
   Created:   2014-05-02
   Purpose:   Counter / order sell price for a sku. Price engine #1 of 3.
              Resolution order: contract price > quote > pro tier > zone > price group > sku.price
   CUST-ID:   CUST-0012 (price path)
   Change log:
     2014-05-02  WH   Initial version (Slatwall price groups)
     2016-02-01  WH   Pro tier discount
     2016-11-07  WH   Zone pricing (T2) - zone resolved from location
     2017-05-22  WH   Commodity pass-through
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_GetSellPrice', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_GetSellPrice
GO
CREATE PROCEDURE dbo.usp_Price_GetSellPrice
    @skuID          CHAR(32),
    @accountID      CHAR(32) = NULL,
    @locationID     CHAR(32) = NULL,
    @quantity       INT = 1,
    @asOf           DATE = NULL,
    @sellPrice      DECIMAL(19,4) OUTPUT,
    @priceGroupID   CHAR(32) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @base DECIMAL(19,4), @list DECIMAL(19,4), @zone CHAR(1), @tier TINYINT, @pct DECIMAL(5,2), @fixed DECIMAL(19,4),
            @floorPct DECIMAL(5,2), @cost DECIMAL(19,4), @contract DECIMAL(19,4), @zonePrice DECIMAL(19,4), @pgRate DECIMAL(19,2),
            @pgType VARCHAR(255), @roundingRuleID CHAR(32), @proAccountID INT, @skuCode VARCHAR(50)

    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    SET @priceGroupID = NULL

    SELECT @base = price, @list = listPrice, @skuCode = skuCode FROM dbo.SwSku WHERE skuID = @skuID
    IF @base IS NULL
    BEGIN
        SET @sellPrice = 0
        RETURN
    END
    SELECT @cost = AvgCost FROM dbo.SwItemMaster_BT WHERE ItemNo = @skuCode

    -- 1. contract price
    IF @accountID IS NOT NULL
    BEGIN
        SELECT TOP 1 @contract = ContractPrice FROM dbo.SwContractPrice
        WHERE accountID = @accountID AND skuID = @skuID AND StartDate <= @asOf AND (EndDate IS NULL OR EndDate >= @asOf) ORDER BY StartDate DESC
        IF @contract IS NOT NULL
        BEGIN
            SET @sellPrice = @contract
            SELECT TOP 1 @priceGroupID = priceGroupID FROM dbo.SwPriceGroup WHERE priceGroupCode = 'CONTRACT'
            RETURN
        END
    END

    -- 2. zone price
    SELECT TOP 1 @zone = PriceZone FROM dbo.SwLocationZone WHERE locationID = @locationID AND EffectiveDate <= @asOf AND (EndDate IS NULL OR EndDate >= @asOf) ORDER BY EffectiveDate DESC
    IF @zone IS NULL SELECT TOP 1 @zone = PriceZone FROM dbo.SwStoreProfile WHERE locationID = @locationID
    IF @zone IS NULL SET @zone = 'A'
    SELECT TOP 1 @zonePrice = ZonePrice FROM dbo.SwZonePrice WHERE skuID = @skuID AND PriceZone = @zone AND EffectiveDate <= @asOf AND (EndDate IS NULL OR EndDate >= @asOf) ORDER BY EffectiveDate DESC
    IF @zonePrice IS NOT NULL SET @base = @zonePrice

    -- 3. pro tier
    SET @tier = dbo.fn_Account_Tier(@accountID)
    IF @accountID IS NOT NULL AND @tier < 5
    BEGIN
        SELECT TOP 1 @pct = DiscountPct, @fixed = FixedPrice, @floorPct = MarginFloorPct
        FROM dbo.SwProTierPrice tp
        WHERE tp.Tier = @tier AND EffectiveDate <= @asOf AND (EndDate IS NULL OR EndDate >= @asOf)
          AND (tp.skuID = @skuID OR (tp.skuID IS NULL AND tp.productTypeID IN (SELECT p.productTypeID FROM dbo.SwSku s JOIN dbo.SwProduct p ON p.productID = s.productID WHERE s.skuID = @skuID)))
        ORDER BY CASE WHEN tp.skuID IS NOT NULL THEN 0 ELSE 1 END
        IF @fixed IS NOT NULL
            SET @sellPrice = @fixed
        ELSE
        BEGIN
            IF @pct IS NULL SET @pct = dbo.fn_Price_TierDiscountPct(@tier)
            SET @sellPrice = @base * (1 - @pct / 100.0)
        END
        -- margin floor (hard-coded fallback 12%, matches FIN-102 §4.2 as of 2016)
        IF @cost IS NOT NULL AND @sellPrice < @cost / (1 - ISNULL(@floorPct, 12.00) / 100.0)
            SET @sellPrice = @cost / (1 - ISNULL(@floorPct, 12.00) / 100.0)
        SELECT TOP 1 @priceGroupID = priceGroupID FROM dbo.SwPriceGroup WHERE priceGroupCode = 'PRO-T' + CAST(@tier AS VARCHAR(1))
        SET @sellPrice = ROUND(@sellPrice, 2)
        RETURN
    END

    -- 4. Slatwall price group rate (retail promos / loyalty groups)
    IF @accountID IS NOT NULL
    BEGIN
        SELECT TOP 1 @priceGroupID = pg.priceGroupID, @pgRate = r.amount, @pgType = r.amountType, @roundingRuleID = r.roundingRuleID
        FROM dbo.SwAccountPriceGroup apg
        JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = apg.priceGroupID AND pg.activeFlag = 1
        JOIN dbo.SwPriceGroupRate r ON r.priceGroupID = pg.priceGroupID
        WHERE apg.accountID = @accountID
          AND (r.globalFlag = 1
               OR EXISTS (SELECT 1 FROM dbo.SwPriceGroupRateSku x WHERE x.priceGroupRateID = r.priceGroupRateID AND x.skuID = @skuID)
               OR EXISTS (SELECT 1 FROM dbo.SwPriceGroupRateProduct x JOIN dbo.SwSku s ON s.productID = x.productID WHERE x.priceGroupRateID = r.priceGroupRateID AND s.skuID = @skuID))
          AND NOT EXISTS (SELECT 1 FROM dbo.SwPriceGroupRateExclSku x WHERE x.priceGroupRateID = r.priceGroupRateID AND x.skuID = @skuID)
        IF @pgRate IS NOT NULL
        BEGIN
            SET @sellPrice = CASE @pgType WHEN 'percentageOff' THEN @base * (1 - @pgRate / 100.0) WHEN 'amountOff' THEN @base - @pgRate WHEN 'amount' THEN @pgRate ELSE @base END
            SET @sellPrice = dbo.fn_Price_RoundByRule(@sellPrice, @roundingRuleID)
            RETURN
        END
    END

    SET @sellPrice = ROUND(@base, 2)
END
GO
