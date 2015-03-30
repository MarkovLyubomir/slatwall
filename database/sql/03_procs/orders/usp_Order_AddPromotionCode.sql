/* =============================================================================
   Procedure: dbo.usp_Order_AddPromotionCode
   Author:    Wade Hollister
   Created:   2014-08-05
   Purpose:   Attach a promo code to an order and evaluate promotions.
   Change log:
     2014-08-05  WH   Initial version
     2015-03-30  WH   Max use count checks
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_AddPromotionCode', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_AddPromotionCode
GO
CREATE PROCEDURE dbo.usp_Order_AddPromotionCode
    @orderID CHAR(32),
    @promotionCode VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @promotionCodeID CHAR(32), @max INT, @used INT, @accountID CHAR(32), @maxAcct INT, @usedAcct INT

    SELECT @promotionCodeID = promotionCodeID, @max = maximumUseCount, @maxAcct = maximumAccountUseCount
    FROM dbo.SwPromotionCode WHERE promotionCode = @promotionCode
      AND (startDateTime IS NULL OR startDateTime <= GETDATE()) AND (endDateTime IS NULL OR endDateTime >= GETDATE())
    IF @promotionCodeID IS NULL
    BEGIN
        RAISERROR('Promotion code not valid', 16, 1)
        RETURN
    END
    SELECT @used = COUNT(*) FROM dbo.SwOrderPromotionCode WHERE promotionCodeID = @promotionCodeID
    IF @max IS NOT NULL AND @used >= @max
    BEGIN
        RAISERROR('Promotion code exhausted', 16, 1)
        RETURN
    END
    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @orderID
    SELECT @usedAcct = COUNT(*) FROM dbo.SwOrderPromotionCode opc JOIN dbo.SwOrder o ON o.orderID = opc.orderID
    WHERE opc.promotionCodeID = @promotionCodeID AND o.accountID = @accountID
    IF @maxAcct IS NOT NULL AND @usedAcct >= @maxAcct
    BEGIN
        RAISERROR('Promotion code already used by this account', 16, 1)
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.SwOrderPromotionCode WHERE orderID = @orderID AND promotionCodeID = @promotionCodeID)
        INSERT dbo.SwOrderPromotionCode (orderID, promotionCodeID) VALUES (@orderID, @promotionCodeID)

    EXEC dbo.usp_Promo_Evaluate @orderID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
