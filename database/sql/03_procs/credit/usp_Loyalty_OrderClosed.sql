/* =============================================================================
   Procedure: dbo.usp_Loyalty_OrderClosed
   Author:    Wade Hollister
   Created:   2015-09-14
   Purpose:   Accrue Slatwall Pro Rewards points: 1 point per $1 merchandise,
              2x for private label (Fairhaven/Ironbark/Slatwall Pro brands).
              Named after the Slatwall event it was ported from; actually called
              at placement.
   Change log:
     2015-09-14  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Loyalty_OrderClosed', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Loyalty_OrderClosed
GO
CREATE PROCEDURE dbo.usp_Loyalty_OrderClosed
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @accountLoyaltyID CHAR(32), @points INT
    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @orderID
    IF NOT EXISTS (SELECT 1 FROM dbo.SwProAccount WHERE accountID = @accountID AND ProRewardsFlag = 1 AND ActiveFlag = 1) RETURN
    SELECT TOP 1 @accountLoyaltyID = accountLoyaltyID FROM dbo.SwAccountLoyalty WHERE accountID = @accountID
    IF @accountLoyaltyID IS NULL
    BEGIN
        SET @accountLoyaltyID = dbo.fn_NewID32()
        INSERT dbo.SwAccountLoyalty (accountLoyaltyID, accountLoyaltyNumber, accountID, loyaltyID, createdDateTime, modifiedDateTime)
        SELECT @accountLoyaltyID, 'PR' + RIGHT(@accountID, 8), @accountID, loyaltyID, GETDATE(), GETDATE() FROM dbo.SwLoyalty WHERE loyaltyName = 'Slatwall Pro Rewards'
    END
    SELECT @points = SUM(CAST(oi.price * oi.quantity AS INT) * CASE WHEN pl.PrivateLabelCode IS NOT NULL THEN 2 ELSE 1 END)
    FROM dbo.SwOrderItem oi JOIN dbo.SwSku s ON s.skuID = oi.skuID JOIN dbo.SwProduct p ON p.productID = s.productID
    LEFT JOIN dbo.SwPrivateLabelProgram pl ON pl.brandID = p.brandID
    WHERE oi.orderID = @orderID AND oi.orderItemTypeID = dbo.fn_GetTypeID('orderItemType','oitSale')
    IF ISNULL(@points, 0) > 0
        INSERT dbo.SwAccountLoyaltyTransaction (accountLoyaltyTransactionID, accruementType, pointsIn, pointsOut, expirationDateTime, accountLoyaltyID, orderID, createdDateTime, modifiedDateTime)
        VALUES (dbo.fn_NewID32(), 'orderClosed', @points, 0, DATEADD(MONTH, 18, GETDATE()), @accountLoyaltyID, @orderID, GETDATE(), GETDATE())
END
GO
