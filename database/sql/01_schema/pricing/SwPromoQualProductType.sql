/* =============================================================================
   Table: dbo.SwPromoQualProductType
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoQualProductType] (
    [productTypeID] CHAR(32) NOT NULL,
    [promotionQualifierID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoQualProductType] PRIMARY KEY CLUSTERED ([productTypeID], [promotionQualifierID])
)
GO
