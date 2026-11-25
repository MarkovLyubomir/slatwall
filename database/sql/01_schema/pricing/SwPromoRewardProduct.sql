/* =============================================================================
   Table: dbo.SwPromoRewardProduct
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoRewardProduct] (
    [productID] CHAR(32) NOT NULL,
    [promotionRewardID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoRewardProduct] PRIMARY KEY CLUSTERED ([productID], [promotionRewardID])
)
GO
