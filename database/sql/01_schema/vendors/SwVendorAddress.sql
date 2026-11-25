/* =============================================================================
   Table: dbo.SwVendorAddress
   Database: SlatwallCommerce
   Slatwall base entity: VendorAddress
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorAddress] (
    [vendorAddressID] CHAR(32) NOT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [vendorID] CHAR(32) NULL,
    [addressID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorAddress] PRIMARY KEY CLUSTERED ([vendorAddressID])
)
GO
