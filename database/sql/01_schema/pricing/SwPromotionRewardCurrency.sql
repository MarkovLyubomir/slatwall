/* =============================================================================
   Table: dbo.SwPromotionRewardCurrency
   Database: SlatwallCommerce
   Slatwall base entity: PromotionRewardCurrency
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionRewardCurrency] (
    [promotionRewardCurrencyID] CHAR(32) NOT NULL,
    [amount] DECIMAL(19,2) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [currencyCode] CHAR(32) NULL,
    [promotionRewardID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromotionRewardCurrency] PRIMARY KEY CLUSTERED ([promotionRewardCurrencyID])
)
GO
