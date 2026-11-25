/* =============================================================================
   Table: dbo.SwPromoRewardSku
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoRewardSku] (
    [promotionRewardID] CHAR(32) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoRewardSku] PRIMARY KEY CLUSTERED ([promotionRewardID], [skuID])
)
GO
