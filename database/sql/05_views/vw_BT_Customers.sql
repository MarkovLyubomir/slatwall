/* =============================================================================
   View:      dbo.vw_BT_Customers
   Author:    Wade Hollister
   Created:   2016-02-01
   Purpose:   Customer/pro feed for Salesforce (IF-07), Billtrust (IF-27) and the
              marketing list pull (IF-19). Exposes email and phone.
   Change log:
     2016-02-01  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_BT_Customers', 'V') IS NOT NULL DROP VIEW dbo.vw_BT_Customers
GO
CREATE VIEW dbo.vw_BT_Customers AS
SELECT a.accountID, a.remoteID AS BTCustomerNo, a.remoteCustomerID AS AdobeCustomerId, a.remoteContactID AS SFDCContactId,
       a.firstName, a.lastName, a.company, ae.emailAddress, ap.phoneNumber,
       pa.ProAccountID, pa.Tier, pa.TradeType, pa.TTMPurchases, pa.SalesRepUser, pa.HomeStoreNumber, pa.ActiveFlag AS ProActive,
       dbo.fn_Credit_Exposure(pa.ProAccountID) AS CreditExposure
FROM dbo.SwAccount a WITH (NOLOCK)
LEFT JOIN dbo.SwAccountEmailAddress ae ON ae.accountEmailAddressID = a.primaryEmailAddressID
LEFT JOIN dbo.SwAccountPhoneNumber ap ON ap.accountPhoneNumberID = a.primaryPhoneNumberID
LEFT JOIN dbo.SwProAccount pa ON pa.accountID = a.accountID AND pa.ActiveFlag = 1
GO
