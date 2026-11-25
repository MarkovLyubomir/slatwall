/* =============================================================================
   Table: dbo.SwPriceGroupRateSku
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroupRateSku] (
    [priceGroupRateID] CHAR(32) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPriceGroupRateSku] PRIMARY KEY CLUSTERED ([priceGroupRateID], [skuID])
)
GO
