/* =============================================================================
   Table: dbo.SwVendorProduct
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorProduct] (
    [productID] CHAR(32) NOT NULL,
    [vendorID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwVendorProduct] PRIMARY KEY CLUSTERED ([productID], [vendorID])
)
GO
