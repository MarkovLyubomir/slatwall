/* =============================================================================
   Table: dbo.SwPriceGroupRate
   Database: SlatwallCommerce
   Slatwall base entity: PriceGroupRate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroupRate] (
    [priceGroupRateID] CHAR(32) NOT NULL,
    [globalFlag] BIT NULL,
    [amount] DECIMAL(19,2) NULL,
    [amountType] VARCHAR(255) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [priceGroupID] CHAR(32) NULL,
    [roundingRuleID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPriceGroupRate] PRIMARY KEY CLUSTERED ([priceGroupRateID])
)
GO
