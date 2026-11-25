/* =============================================================================
   Table: dbo.SwPromoRewardProductType
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoRewardProductType] (
    [productTypeID] CHAR(32) NOT NULL,
    [promotionRewardID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoRewardProductType] PRIMARY KEY CLUSTERED ([productTypeID], [promotionRewardID])
)
GO
