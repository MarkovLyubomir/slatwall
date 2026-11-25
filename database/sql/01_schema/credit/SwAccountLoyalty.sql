/* =============================================================================
   Table: dbo.SwAccountLoyalty
   Database: SlatwallCommerce
   Slatwall base entity: AccountLoyalty
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountLoyalty] (
    [accountLoyaltyID] CHAR(32) NOT NULL,
    [accountLoyaltyNumber] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [loyaltyID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountLoyalty] PRIMARY KEY CLUSTERED ([accountLoyaltyID])
)
GO
