/* =============================================================================
   Table: dbo.SwVendorEmailAddress
   Database: SlatwallCommerce
   Slatwall base entity: VendorEmailAddress
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorEmailAddress] (
    [vendorEmailAddressID] CHAR(32) NOT NULL,
    [emailAddress] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [vendorID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorEmailAddress] PRIMARY KEY CLUSTERED ([vendorEmailAddressID])
)
GO
