/* =============================================================================
   Table: dbo.SwPromotionPeriod
   Database: SlatwallCommerce
   Slatwall base entity: PromotionPeriod
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionPeriod] (
    [promotionPeriodID] CHAR(32) NOT NULL,
    [startDateTime] DATETIME NULL,
    [endDateTime] DATETIME NULL,
    [maximumUseCount] INT NULL,
    [maximumAccountUseCount] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [promotionID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromotionPeriod] PRIMARY KEY CLUSTERED ([promotionPeriodID])
)
GO
