/* =============================================================================
   Table: dbo.SwAccountLoyaltyTransaction
   Database: SlatwallCommerce
   Slatwall base entity: AccountLoyaltyTransaction
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountLoyaltyTransaction] (
    [accountLoyaltyTransactionID] CHAR(32) NOT NULL,
    [accruementType] VARCHAR(255) NULL,
    [redemptionType] VARCHAR(255) NULL,
    [pointsIn] INT NULL,
    [pointsOut] INT NULL,
    [expirationDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountLoyaltyID] CHAR(32) NULL,
    [loyaltyAccruementID] CHAR(32) NULL,
    [loyaltyRedemptionID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    [orderFulfillmentID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountLoyaltyTransaction] PRIMARY KEY CLUSTERED ([accountLoyaltyTransactionID])
)
GO

-- NOTE: [loyaltyAccruementID] references the former SwLoyaltyAccruement table (dropped 2017); column retained.
-- NOTE: [loyaltyRedemptionID] references the former SwLoyaltyRedemption table (dropped 2017); column retained.