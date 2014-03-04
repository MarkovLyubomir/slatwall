/* =============================================================================
   Table: dbo.SwPromotion
   Database: SlatwallCommerce
   Slatwall base entity: Promotion
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotion] (
    [promotionID] CHAR(32) NOT NULL,
    [promotionName] VARCHAR(255) NULL,
    [promotionSummary] VARCHAR(1000) NULL,
    [promotionDescription] VARCHAR(4000) NULL,
    [activeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [defaultImageID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromotion] PRIMARY KEY CLUSTERED ([promotionID])
)
GO
