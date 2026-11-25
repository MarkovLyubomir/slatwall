/* =============================================================================
   Table: dbo.SwStockAdjustmentDeliveryItem
   Database: SlatwallCommerce
   Slatwall base entity: StockAdjustmentDeliveryItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockAdjustmentDeliveryItem] (
    [stockAdjustmentDeliveryItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [stockAdjustmentDeliveryID] CHAR(32) NULL,
    [stockAdjustmentItemID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockAdjustmentDeliveryItem] PRIMARY KEY CLUSTERED ([stockAdjustmentDeliveryItemID])
)
GO
