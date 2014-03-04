/* =============================================================================
   Table: dbo.SwVendorSkuStock
   Database: SlatwallCommerce
   Slatwall base entity: VendorSkuStock
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorSkuStock] (
    [vendorSkuStockID] CHAR(32) NOT NULL,
    [cost] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [quantity] INT NULL,
    [availableDateTime] DATETIME NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [skuID] CHAR(32) NULL,
    [vendorID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorSkuStock] PRIMARY KEY CLUSTERED ([vendorSkuStockID])
)
GO
