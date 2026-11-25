/* =============================================================================
   Table: dbo.SwVendorAccount
   Database: SlatwallCommerce
   Slatwall base entity: VendorAccount
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorAccount] (
    [vendorAccountID] CHAR(32) NOT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [vendorID] CHAR(32) NULL,
    [accountID] CHAR(32) NULL,
    [roleTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorAccount] PRIMARY KEY CLUSTERED ([vendorAccountID])
)
GO
