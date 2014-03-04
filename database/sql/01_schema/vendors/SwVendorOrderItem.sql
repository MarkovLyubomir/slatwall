/* =============================================================================
   Table: dbo.SwVendorOrderItem
   Database: SlatwallCommerce
   Slatwall base entity: VendorOrderItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorOrderItem] (
    [vendorOrderItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [cost] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [estimatedReceivalDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [vendorOrderItemTypeID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    [vendorOrderID] CHAR(32) NULL,
    CONSTRAINT [PK_SwVendorOrderItem] PRIMARY KEY CLUSTERED ([vendorOrderItemID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwVendorOrderItem_vendorOrderID] ON [dbo].[SwVendorOrderItem] ([vendorOrderID])
GO
