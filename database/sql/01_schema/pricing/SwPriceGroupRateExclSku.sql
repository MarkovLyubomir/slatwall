/* =============================================================================
   Table: dbo.SwPriceGroupRateExclSku
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroupRateExclSku] (
    [priceGroupRateID] CHAR(32) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPriceGroupRateExclSku] PRIMARY KEY CLUSTERED ([priceGroupRateID], [skuID])
)
GO
