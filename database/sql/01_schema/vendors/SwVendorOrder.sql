/* =============================================================================
   Table: dbo.SwVendorOrder
   Database: SlatwallCommerce
   Slatwall base entity: VendorOrder
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorOrder] (
    [vendorOrderID] CHAR(32) NOT NULL,
    [vendorOrderNumber] VARCHAR(255) NULL,
    [estimatedReceivalDateTime] DATETIME NULL,
    [currencyCode] VARCHAR(3) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationID] CHAR(32) NULL,
    [vendorID] CHAR(32) NULL,
    [vendorOrderTypeID] CHAR(32) NULL,
    [vendorOrderStatusTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorOrder] PRIMARY KEY CLUSTERED ([vendorOrderID])
)
GO
