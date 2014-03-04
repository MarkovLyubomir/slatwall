/* =============================================================================
   Table: dbo.SwPriceGroupRateProduct
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroupRateProduct] (
    [priceGroupRateID] CHAR(32) NOT NULL,
    [productID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPriceGroupRateProduct] PRIMARY KEY CLUSTERED ([priceGroupRateID], [productID])
)
GO
