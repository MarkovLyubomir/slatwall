/* =============================================================================
   Procedure: dbo.usp_Promo_ApplyReward
   Author:    Wade Hollister
   Created:   2014-08-05
   Purpose:   Write SwPromotionApplied rows for a reward: item rewards per
              qualifying line, order rewards once, fulfillment rewards per fulfillment.
   Change log:
     2014-08-05  WH   Initial version
     2019-04-15  PN   Fulfillment rewards
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Promo_ApplyReward', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Promo_ApplyReward
GO
CREATE PROCEDURE dbo.usp_Promo_ApplyReward
    @orderID CHAR(32),
    @promotionID CHAR(32),
    @promotionRewardID CHAR(32),
    @amount DECIMAL(19,2),
    @amountType VARCHAR(255)       -- percentageOff | amountOff | fixedAmount
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @hasItemScope BIT, @hasFulfillScope BIT
    SET @hasItemScope = CASE WHEN EXISTS (SELECT 1 FROM dbo.SwPromoRewardSku WHERE promotionRewardID = @promotionRewardID)
                                OR EXISTS (SELECT 1 FROM dbo.SwPromoRewardProduct WHERE promotionRewardID = @promotionRewardID)
                                OR EXISTS (SELECT 1 FROM dbo.SwPromoRewardBrand WHERE promotionRewardID = @promotionRewardID)
                                OR EXISTS (SELECT 1 FROM dbo.SwPromoRewardProductType WHERE promotionRewardID = @promotionRewardID) THEN 1 ELSE 0 END
    SET @hasFulfillScope = CASE WHEN EXISTS (SELECT 1 FROM dbo.SwPromoRewardFulfillmentMethod WHERE promotionRewardID = @promotionRewardID) THEN 1 ELSE 0 END

    IF @hasItemScope = 1
        INSERT dbo.SwPromotionApplied (promotionAppliedID, discountAmount, appliedType, currencyCode, promotionID, orderItemID, createdDateTime)
        SELECT dbo.fn_NewID32(),
               CASE @amountType WHEN 'percentageOff' THEN ROUND(oi.price * oi.quantity * @amount / 100.0, 2)
                                WHEN 'amountOff' THEN @amount * oi.quantity
                                ELSE (oi.price - @amount) * oi.quantity END,
               'orderItem', 'USD', @promotionID, oi.orderItemID, GETDATE()
        FROM dbo.SwOrderItem oi JOIN dbo.SwSku s ON s.skuID = oi.skuID JOIN dbo.SwProduct p ON p.productID = s.productID
        WHERE oi.orderID = @orderID AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
          AND (oi.skuID IN (SELECT skuID FROM dbo.SwPromoRewardSku WHERE promotionRewardID = @promotionRewardID)
               OR p.productID IN (SELECT productID FROM dbo.SwPromoRewardProduct WHERE promotionRewardID = @promotionRewardID)
               OR p.brandID IN (SELECT brandID FROM dbo.SwPromoRewardBrand WHERE promotionRewardID = @promotionRewardID)
               OR p.productTypeID IN (SELECT productTypeID FROM dbo.SwPromoRewardProductType WHERE promotionRewardID = @promotionRewardID))
          AND oi.skuID NOT IN (SELECT skuID FROM dbo.SwPromoRewardExclSku WHERE promotionRewardID = @promotionRewardID)
    ELSE IF @hasFulfillScope = 1
        INSERT dbo.SwPromotionApplied (promotionAppliedID, discountAmount, appliedType, currencyCode, promotionID, orderFulfillmentID, orderID, createdDateTime)
        SELECT dbo.fn_NewID32(),
               CASE @amountType WHEN 'percentageOff' THEN ROUND(f.fulfillmentCharge * @amount / 100.0, 2) ELSE ISNULL(f.fulfillmentCharge, 0) END,
               'orderFulfillment', 'USD', @promotionID, f.orderFulfillmentID, @orderID, GETDATE()
        FROM dbo.SwOrderFulfillment f WHERE f.orderID = @orderID
          AND f.fulfillmentMethodID IN (SELECT fulfillmentMethodID FROM dbo.SwPromoRewardFulfillmentMethod WHERE promotionRewardID = @promotionRewardID)
    ELSE
        INSERT dbo.SwPromotionApplied (promotionAppliedID, discountAmount, appliedType, currencyCode, promotionID, orderID, createdDateTime)
        VALUES (dbo.fn_NewID32(),
                CASE @amountType WHEN 'percentageOff' THEN ROUND(dbo.fn_Order_Subtotal(@orderID) * @amount / 100.0, 2) ELSE @amount END,
                'order', 'USD', @promotionID, @orderID, GETDATE())
END
GO
