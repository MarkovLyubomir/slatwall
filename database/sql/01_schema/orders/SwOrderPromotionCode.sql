/* =============================================================================
   Table: dbo.SwOrderPromotionCode
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderPromotionCode] (
    [orderID] CHAR(32) NOT NULL,
    [promotionCodeID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwOrderPromotionCode] PRIMARY KEY CLUSTERED ([orderID], [promotionCodeID])
)
GO
