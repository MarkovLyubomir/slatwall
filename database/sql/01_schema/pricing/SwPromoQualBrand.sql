/* =============================================================================
   Table: dbo.SwPromoQualBrand
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoQualBrand] (
    [brandID] CHAR(32) NOT NULL,
    [promotionQualifierID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoQualBrand] PRIMARY KEY CLUSTERED ([brandID], [promotionQualifierID])
)
GO
