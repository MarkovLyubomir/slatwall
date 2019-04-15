/* =============================================================================
   Procedure: dbo.usp_Promo_Evaluate
   Author:    Wade Hollister
   Created:   2014-08-05
   Purpose:   Evaluate active promotions against an order and write
              SwPromotionApplied rows. Supports: order subtotal qualifiers,
              sku/product/brand rewards, percentage or amount off. The
              Slatwall qualifier model is far richer; this covers what Slatwall
              Building Supply actually used (two promos a year).
   Change log:
     2014-08-05  WH   Initial version
     2015-03-30  WH   Promo code gating
     2019-04-15  PN   Fulfillment-method rewards (free delivery)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Promo_Evaluate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Promo_Evaluate
GO
CREATE PROCEDURE dbo.usp_Promo_Evaluate
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subtotal DECIMAL(19,2), @periodID CHAR(32), @promotionID CHAR(32), @rewardID CHAR(32), @amount DECIMAL(19,2), @amountType VARCHAR(255),
            @minSub DECIMAL(19,2), @maxSub DECIMAL(19,2), @currency VARCHAR(3), @needsCode BIT

    DELETE dbo.SwPromotionApplied WHERE orderID = @orderID OR orderItemID IN (SELECT orderItemID FROM dbo.SwOrderItem WHERE orderID = @orderID)
    SET @subtotal = dbo.fn_Order_Subtotal(@orderID)

    DECLARE c CURSOR LOCAL FOR
        SELECT pp.promotionPeriodID, p.promotionID
        FROM dbo.SwPromotion p JOIN dbo.SwPromotionPeriod pp ON pp.promotionID = p.promotionID
        WHERE p.activeFlag = 1 AND (pp.startDateTime IS NULL OR pp.startDateTime <= GETDATE()) AND (pp.endDateTime IS NULL OR pp.endDateTime >= GETDATE())
    OPEN c
    FETCH NEXT FROM c INTO @periodID, @promotionID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- code gating: if the promotion has codes, the order must carry one
        SET @needsCode = CASE WHEN EXISTS (SELECT 1 FROM dbo.SwPromotionCode WHERE promotionID = @promotionID) THEN 1 ELSE 0 END
        IF @needsCode = 0 OR EXISTS (SELECT 1 FROM dbo.SwOrderPromotionCode opc JOIN dbo.SwPromotionCode pc ON pc.promotionCodeID = opc.promotionCodeID WHERE opc.orderID = @orderID AND pc.promotionID = @promotionID)
        BEGIN
            -- qualifiers: order subtotal range (only qualifier type ever configured)
            SELECT @minSub = MIN(minimumOrderSubtotal), @maxSub = MAX(maximumOrderSubtotal) FROM dbo.SwPromoQual WHERE promotionPeriodID = @periodID AND qualifierType = 'order'
            IF (@minSub IS NULL OR @subtotal >= @minSub) AND (@maxSub IS NULL OR @subtotal <= @maxSub)
            BEGIN
                DECLARE r CURSOR LOCAL FOR
                    SELECT pr.promotionRewardID, ISNULL(rc.amount, pr.amount), pr.amountType
                    FROM dbo.SwPromoReward pr LEFT JOIN dbo.SwPromotionRewardCurrency rc ON rc.promotionRewardID = pr.promotionRewardID AND rc.currencyCode = 'USD'
                    WHERE pr.promotionPeriodID = @periodID
                OPEN r
                FETCH NEXT FROM r INTO @rewardID, @amount, @amountType
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    EXEC dbo.usp_Promo_ApplyReward @orderID = @orderID, @promotionID = @promotionID, @promotionRewardID = @rewardID, @amount = @amount, @amountType = @amountType
                    FETCH NEXT FROM r INTO @rewardID, @amount, @amountType
                END
                CLOSE r DEALLOCATE r
            END
        END
        FETCH NEXT FROM c INTO @periodID, @promotionID
    END
    CLOSE c DEALLOCATE c
END
GO
