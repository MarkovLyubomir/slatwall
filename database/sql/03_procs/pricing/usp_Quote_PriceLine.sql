/* =============================================================================
   Procedure: dbo.usp_Quote_PriceLine
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Price a quote line. Price engine #3 of 3. Quotes use the pro tier
              discount off ZONE price and then the estimator's job-size break -
              neither usp_Price_GetSellPrice nor usp_Web_GetPrice does this.
   CUST-ID:   CUST-0071 (price path)
   Change log:
     2016-03-14  WH   Initial version
     2018-02-19  WH   Job-size break: >$25k subtotal gets extra 2%, >$100k extra 4%
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_PriceLine', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_PriceLine
GO
CREATE PROCEDURE dbo.usp_Quote_PriceLine
    @quoteLineID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @quoteID INT, @skuID CHAR(32), @qty DECIMAL(12,3), @accountID CHAR(32), @store TINYINT, @zone CHAR(1), @base DECIMAL(19,4),
            @tier TINYINT, @pct DECIMAL(5,2), @subtotal DECIMAL(19,2), @jobBreak DECIMAL(5,2), @price DECIMAL(19,4), @cost DECIMAL(19,4)

    SELECT @quoteID = ql.QuoteID, @skuID = ql.skuID, @qty = ql.Qty, @cost = ql.UnitCost, @accountID = q.accountID, @store = q.StoreNumber
    FROM dbo.SwQuoteLine ql JOIN dbo.SwQuote q ON q.QuoteID = ql.QuoteID WHERE ql.QuoteLineID = @quoteLineID

    SELECT @zone = PriceZone FROM dbo.SwStoreProfile WHERE StoreNumber = @store
    SELECT TOP 1 @base = ZonePrice FROM dbo.SwZonePrice WHERE skuID = @skuID AND PriceZone = ISNULL(@zone, 'A') AND EndDate IS NULL ORDER BY EffectiveDate DESC
    IF @base IS NULL SELECT @base = price FROM dbo.SwSku WHERE skuID = @skuID

    SET @tier = dbo.fn_Account_Tier(@accountID)
    SET @pct = CASE @tier WHEN 1 THEN 20.00 WHEN 2 THEN 16.00 WHEN 3 THEN 12.00 WHEN 4 THEN 8.00 ELSE 4.00 END   -- quote discounts (SAL-205 appendix A, 2016)

    SELECT @subtotal = ISNULL(SUM(Qty * ISNULL(UnitPrice, 0)), 0) FROM dbo.SwQuoteLine WHERE QuoteID = @quoteID
    SET @jobBreak = CASE WHEN @subtotal > 100000 THEN 4.00 WHEN @subtotal > 25000 THEN 2.00 ELSE 0 END

    SET @price = @base * (1 - (@pct + @jobBreak) / 100.0)
    UPDATE dbo.SwQuoteLine SET UnitPrice = ROUND(@price, 2),
                               LineMarginPct = CASE WHEN @price > 0 AND @cost IS NOT NULL THEN ROUND((@price - @cost) / @price * 100, 2) END
    WHERE QuoteLineID = @quoteLineID
END
GO
