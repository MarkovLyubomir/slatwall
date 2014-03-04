/* =============================================================================
   Table: dbo.SwAccountPriceGroup
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountPriceGroup] (
    [accountID] CHAR(32) NOT NULL,
    [priceGroupID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwAccountPriceGroup] PRIMARY KEY CLUSTERED ([accountID], [priceGroupID])
)
GO
