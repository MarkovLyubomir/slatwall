/* =============================================================================
   Table: dbo.SwPromotionCodeAccount
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionCodeAccount] (
    [accountID] CHAR(32) NOT NULL,
    [promotionCodeID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromotionCodeAccount] PRIMARY KEY CLUSTERED ([accountID], [promotionCodeID])
)
GO
