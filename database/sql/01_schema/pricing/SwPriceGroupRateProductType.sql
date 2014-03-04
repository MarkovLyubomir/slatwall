/* =============================================================================
   Table: dbo.SwPriceGroupRateProductType
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroupRateProductType] (
    [priceGroupRateID] CHAR(32) NOT NULL,
    [productTypeID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPriceGroupRateProductType] PRIMARY KEY CLUSTERED ([priceGroupRateID], [productTypeID])
)
GO
