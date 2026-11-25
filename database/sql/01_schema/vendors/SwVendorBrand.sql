/* =============================================================================
   Table: dbo.SwVendorBrand
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorBrand] (
    [brandID] CHAR(32) NOT NULL,
    [vendorID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwVendorBrand] PRIMARY KEY CLUSTERED ([brandID], [vendorID])
)
GO
