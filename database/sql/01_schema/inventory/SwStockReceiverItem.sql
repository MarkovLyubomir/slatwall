/* =============================================================================
   Table: dbo.SwStockReceiverItem
   Database: SlatwallCommerce
   Slatwall base entity: StockReceiverItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockReceiverItem] (
    [stockReceiverItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [cost] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [stockID] CHAR(32) NULL,
    [stockReceiverID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    [vendorOrderItemID] CHAR(32) NULL,
    [stockAdjustmentItemID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockReceiverItem] PRIMARY KEY CLUSTERED ([stockReceiverItemID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwStockReceiverItem_stockReceiverID] ON [dbo].[SwStockReceiverItem] ([stockReceiverID])
GO
