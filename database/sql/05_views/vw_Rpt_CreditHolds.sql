/* =============================================================================
   View:      dbo.vw_Rpt_CreditHolds
   Author:    Wade Hollister
   Created:   2017-01-23
   Purpose:   Active holds and overrides for the credit team dashboard. Added the
              override columns in 2026 for Internal Audit.
   Change log:
     2017-01-23  WH   Initial version
     2026-06-29  WH   Override detail
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Rpt_CreditHolds', 'V') IS NOT NULL DROP VIEW dbo.vw_Rpt_CreditHolds
GO
CREATE VIEW dbo.vw_Rpt_CreditHolds AS
SELECT h.CreditHoldID, pa.BTCustomerNo, pa.CompanyName, pa.Tier, pa.HomeStoreNumber, h.HoldReason, h.HoldDate, h.HoldBy, h.ExposureAtHold,
       h.ReleasedDate, h.ReleasedBy, h.ReleaseAuthorityLevel, h.OverrideFlag, h.OverrideJustificationCode, h.OverrideStore, h.Notes,
       dbo.fn_Credit_Exposure(pa.ProAccountID) AS CurrentExposure
FROM dbo.SwCreditHold h JOIN dbo.SwProAccount pa ON pa.ProAccountID = h.ProAccountID
GO
