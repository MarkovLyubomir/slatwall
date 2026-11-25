/* =============================================================================
   Table: dbo.SwRelatedProduct
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwRelatedProduct] (
    [productID] CHAR(32) NOT NULL,
    [relatedProductID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwRelatedProduct] PRIMARY KEY CLUSTERED ([productID], [relatedProductID])
)
GO
