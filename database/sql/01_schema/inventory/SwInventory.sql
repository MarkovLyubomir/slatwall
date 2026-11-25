/* =============================================================================
   Table: dbo.SwInventory
   Database: SlatwallCommerce
   Slatwall base entity: Inventory
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwInventory] (
    [inventoryID] CHAR(32) NOT NULL,
    [quantityIn] INT NULL,
    [quantityOut] INT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [stockID] CHAR(32) NULL,
    [stockReceiverItemID] CHAR(32) NULL,
    [orderDeliveryItemID] CHAR(32) NULL,
    [stockAdjustmentDeliveryItemID] CHAR(32) NULL,
    CONSTRAINT [PK_SwInventory] PRIMARY KEY CLUSTERED ([inventoryID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwInventory_stockID] ON [dbo].[SwInventory] ([stockID])
GO
