/* =============================================================================
   Procedure: dbo.usp_Price_ResolvePriceGroup
   Author:    Wade Hollister
   Created:   2014-05-02
   Purpose:   Which price group applies to an account (first active one, by path).
   Change log:
     2014-05-02  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Price_ResolvePriceGroup', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Price_ResolvePriceGroup
GO
CREATE PROCEDURE dbo.usp_Price_ResolvePriceGroup
    @accountID CHAR(32),
    @priceGroupID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP 1 @priceGroupID = pg.priceGroupID
    FROM dbo.SwAccountPriceGroup apg JOIN dbo.SwPriceGroup pg ON pg.priceGroupID = apg.priceGroupID
    WHERE apg.accountID = @accountID AND pg.activeFlag = 1
    ORDER BY LEN(pg.priceGroupIDPath) DESC
END
GO
