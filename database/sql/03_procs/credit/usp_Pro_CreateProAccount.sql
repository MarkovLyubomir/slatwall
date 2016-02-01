/* =============================================================================
   Procedure: dbo.usp_Pro_CreateProAccount
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Promote a SwAccount to a pro/trade account (tier 5 by default) and
              copy the name/address fields across so the pro desk screen can
              read one table.
   Change log:
     2016-02-01  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pro_CreateProAccount', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pro_CreateProAccount
GO
CREATE PROCEDURE dbo.usp_Pro_CreateProAccount
    @accountID CHAR(32),
    @btCustomerNo VARCHAR(20),
    @tradeType VARCHAR(30) = NULL,
    @homeStoreNumber TINYINT = NULL,
    @salesRepUser VARCHAR(50) = NULL,
    @proAccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (SELECT 1 FROM dbo.SwProAccount WHERE accountID = @accountID AND ActiveFlag = 1)
    BEGIN
        SELECT @proAccountID = ProAccountID FROM dbo.SwProAccount WHERE accountID = @accountID AND ActiveFlag = 1
        RETURN
    END
    INSERT dbo.SwProAccount (accountID, BTCustomerNo, CompanyName, TradeType, Tier, TierEffectiveDate, SalesRepUser, HomeStoreNumber, BillingAddress1, BillingCity, BillingState, BillingZip, Phone)
    SELECT a.accountID, @btCustomerNo, a.company, @tradeType, 5, CAST(GETDATE() AS DATE), @salesRepUser, @homeStoreNumber, ad.streetAddress, ad.city, ad.stateCode, ad.postalCode, ad.phoneNumber
    FROM dbo.SwAccount a LEFT JOIN dbo.SwAccountAddress aa ON aa.accountAddressID = a.primaryBillingAddressID LEFT JOIN dbo.SwAddress ad ON ad.addressID = aa.addressID
    WHERE a.accountID = @accountID
    SET @proAccountID = SCOPE_IDENTITY()
    UPDATE dbo.SwAccount SET remoteID = @btCustomerNo WHERE accountID = @accountID AND remoteID IS NULL
    -- legacy price group assignment so the 2016 pricing path still works
    INSERT dbo.SwAccountPriceGroup (accountID, priceGroupID) SELECT @accountID, priceGroupID FROM dbo.SwPriceGroup WHERE priceGroupCode = 'PRO-T5'
      AND NOT EXISTS (SELECT 1 FROM dbo.SwAccountPriceGroup WHERE accountID = @accountID)
END
GO
