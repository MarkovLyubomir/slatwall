/* =============================================================================
   Table: dbo.SwPromoQual
   Database: SlatwallCommerce
   Slatwall base entity: PromotionQualifier
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoQual] (
    [promotionQualifierID] CHAR(32) NOT NULL,
    [qualifierType] VARCHAR(255) NULL,
    [minimumOrderQuantity] INT NULL,
    [maximumOrderQuantity] INT NULL,
    [minimumOrderSubtotal] DECIMAL(19,2) NULL,
    [maximumOrderSubtotal] DECIMAL(19,2) NULL,
    [minimumItemQuantity] INT NULL,
    [maximumItemQuantity] INT NULL,
    [minimumItemPrice] DECIMAL(19,2) NULL,
    [maximumItemPrice] DECIMAL(19,2) NULL,
    [minimumFulfillmentWeight] DECIMAL(19,2) NULL,
    [maximumFulfillmentWeight] DECIMAL(19,2) NULL,
    [rewardMatchingType] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [promotionPeriodID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromoQual] PRIMARY KEY CLUSTERED ([promotionQualifierID])
)
GO
