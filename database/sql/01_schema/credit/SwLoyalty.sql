/* =============================================================================
   Table: dbo.SwLoyalty
   Database: SlatwallCommerce
   Slatwall base entity: Loyalty
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLoyalty] (
    [loyaltyID] CHAR(32) NOT NULL,
    [loyaltyName] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwLoyalty] PRIMARY KEY CLUSTERED ([loyaltyID])
)
GO
