/* =============================================================================
   Table: dbo.SwVendor
   Database: SlatwallCommerce
   Slatwall base entity: Vendor
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendor] (
    [vendorID] CHAR(32) NOT NULL,
    [vendorName] VARCHAR(255) NULL,
    [vendorWebsite] VARCHAR(255) NULL,
    [accountNumber] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [primaryEmailAddressID] CHAR(32) NULL,
    [primaryPhoneNumberID] CHAR(32) NULL,
    [primaryAddressID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendor] PRIMARY KEY CLUSTERED ([vendorID])
)
GO
