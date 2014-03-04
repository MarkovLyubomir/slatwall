/* =============================================================================
   Table: dbo.SwPromotionCode
   Database: SlatwallCommerce
   Slatwall base entity: PromotionCode
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionCode] (
    [promotionCodeID] CHAR(32) NOT NULL,
    [promotionCode] VARCHAR(255) NULL,
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
    CONSTRAINT [PK_SwPromotionCode] PRIMARY KEY CLUSTERED ([promotionCodeID])
)
GO
