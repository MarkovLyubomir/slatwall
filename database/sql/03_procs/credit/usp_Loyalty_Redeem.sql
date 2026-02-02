/* =============================================================================
   Procedure: dbo.usp_Loyalty_Redeem
   Author:    Wade Hollister
   Created:   2026-02-02
   Purpose:   Redeem points as an order-level discount (100 points = $1).
   Change log:
     2026-02-02  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Loyalty_Redeem', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Loyalty_Redeem
GO
CREATE PROCEDURE dbo.usp_Loyalty_Redeem
    @orderID CHAR(32),
    @points INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @accountLoyaltyID CHAR(32), @balance INT, @promotionID CHAR(32)
    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @orderID
    SELECT TOP 1 @accountLoyaltyID = accountLoyaltyID FROM dbo.SwAccountLoyalty WHERE accountID = @accountID
    SELECT @balance = ISNULL(SUM(pointsIn), 0) - ISNULL(SUM(pointsOut), 0) FROM dbo.SwAccountLoyaltyTransaction WHERE accountLoyaltyID = @accountLoyaltyID AND (expirationDateTime IS NULL OR expirationDateTime > GETDATE())
    IF @balance < @points
    BEGIN
        RAISERROR('Insufficient points (%d available)', 16, 1, @balance)
        RETURN
    END
    SELECT TOP 1 @promotionID = promotionID FROM dbo.SwPromotion WHERE promotionName = 'Pro Rewards Redemption'
    INSERT dbo.SwAccountLoyaltyTransaction (accountLoyaltyTransactionID, redemptionType, pointsIn, pointsOut, accountLoyaltyID, orderID, createdDateTime, modifiedDateTime)
    VALUES (dbo.fn_NewID32(), 'order', 0, @points, @accountLoyaltyID, @orderID, GETDATE(), GETDATE())
    INSERT dbo.SwPromotionApplied (promotionAppliedID, discountAmount, appliedType, currencyCode, promotionID, orderID, createdDateTime)
    VALUES (dbo.fn_NewID32(), @points / 100.0, 'order', 'USD', @promotionID, @orderID, GETDATE())
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
