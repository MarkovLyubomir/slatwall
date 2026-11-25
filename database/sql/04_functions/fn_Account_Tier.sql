/* =============================================================================
   Function:  dbo.fn_Account_Tier
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Current pro tier for an account (5 = lowest / default).
   Change log:
     2016-02-01  WH   Initial version
     2024-02-05  WH   Read from SwProAccount instead of the priceGroupCode prefix
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Account_Tier') IS NOT NULL DROP FUNCTION dbo.fn_Account_Tier
GO
CREATE FUNCTION dbo.fn_Account_Tier(@accountID CHAR(32))
RETURNS TINYINT
AS
BEGIN
    DECLARE @tier TINYINT
    SELECT TOP 1 @tier = Tier FROM dbo.SwProAccount WHERE accountID = @accountID AND ActiveFlag = 1 ORDER BY ProAccountID DESC
    IF @tier IS NULL
    BEGIN
        -- legacy path: tier encoded in price group code 'PRO-T3'
        SELECT TOP 1 @tier = TRY_CAST(RIGHT(pg.priceGroupCode, 1) AS TINYINT)
        FROM dbo.SwAccountPriceGroup apg JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = apg.priceGroupID
        WHERE apg.accountID = @accountID AND pg.priceGroupCode LIKE 'PRO-T%'
    END
    RETURN ISNULL(@tier, 5)
END
GO
