/* =============================================================================
   Table: dbo.SwPromoReward
   Database: SlatwallCommerce
   Slatwall base entity: PromotionReward
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoReward] (
    [promotionRewardID] CHAR(32) NOT NULL,
    [amount] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [amountType] VARCHAR(255) NULL,
    [rewardType] VARCHAR(255) NULL,
    [applicableTerm] VARCHAR(255) NULL,
    [maximumUsePerOrder] INT NULL,
    [maximumUsePerItem] INT NULL,
    [maximumUsePerQualification] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [promotionPeriodID] CHAR(32) NULL,
    [roundingRuleID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromoReward] PRIMARY KEY CLUSTERED ([promotionRewardID])
)
GO
