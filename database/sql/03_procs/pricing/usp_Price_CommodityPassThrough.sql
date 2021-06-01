/* =============================================================================
   Procedure: dbo.usp_Price_CommodityPassThrough
   Author:    Wade Hollister
   Created:   2017-05-22
   Purpose:   Re-price commodity lumber lines on an order against the latest
              index value (T2 §5 commodity pass-through). Cursor over lines,
              one index lookup per line.
   CUST-ID:   CUST-0088 (price path)
   Change log:
     2017-05-22  WH   Initial version
     2021-06-01  WH   Quoted lines are frozen for the quote validity window
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_CommodityPassThrough', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_CommodityPassThrough
GO
CREATE PROCEDURE dbo.usp_Price_CommodityPassThrough
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @oiID CHAR(32), @skuID CHAR(32), @price DECIMAL(19,2), @idx VARCHAR(20), @bf DECIMAL(10,4), @pct DECIMAL(5,2),
            @idxVal DECIMAL(10,2), @idxBase DECIMAL(10,2), @newPrice DECIMAL(19,4), @cost DECIMAL(19,4)

    IF dbo.fn_Order_StatusCode(@orderID) <> 'ostNotPlaced' RETURN

    DECLARE c CURSOR LOCAL FOR
        SELECT oi.orderItemID, oi.skuID, oi.price FROM dbo.SwOrderItem oi
        LEFT JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = oi.appliedPriceGroupID
        WHERE oi.orderID = @orderID AND dbo.fn_Sku_IsCommodity(oi.skuID) = 1 AND ISNULL(pg.priceGroupCode, '') NOT LIKE 'QUOTE%'
    OPEN c
    FETCH NEXT FROM c INTO @oiID, @skuID, @price
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT TOP 1 @idx = IndexCode, @bf = BoardFeetPerUnit, @pct = PassThroughPct FROM dbo.SwSkuCommodityLink WHERE skuID = @skuID ORDER BY EffectiveDate DESC
        IF @idx IS NOT NULL
        BEGIN
            SELECT TOP 1 @idxVal = IndexValue FROM dbo.SwCommodityIndex WHERE IndexCode = @idx ORDER BY IndexDate DESC
            -- base = index value 4 weeks ago (the "list" the zone price was set against)
            SELECT TOP 1 @idxBase = IndexValue FROM dbo.SwCommodityIndex WHERE IndexCode = @idx AND IndexDate <= DATEADD(WEEK, -4, GETDATE()) ORDER BY IndexDate DESC
            IF @idxVal IS NOT NULL AND @idxBase IS NOT NULL AND @idxBase <> 0
            BEGIN
                SET @newPrice = @price + (@idxVal - @idxBase) / 1000.0 * @bf * (@pct / 100.0)
                UPDATE dbo.SwOrderItem SET price = ROUND(@newPrice, 2), modifiedDateTime = GETDATE() WHERE orderItemID = @oiID
            END
        END
        FETCH NEXT FROM c INTO @oiID, @skuID, @price
    END
    CLOSE c DEALLOCATE c
END
GO
