/* =============================================================================
   Table: dbo.SwPromotionAccount
   Database: SlatwallCommerce
   Slatwall base entity: PromotionAccount
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionAccount] (
    [promotionAccountID] CHAR(32) NOT NULL,
    [startDateTime] DATETIME NULL,
    [endDateTime] DATETIME NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [promotionID] CHAR(32) NULL,
    [accountID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromotionAccount] PRIMARY KEY CLUSTERED ([promotionAccountID])
)
GO
