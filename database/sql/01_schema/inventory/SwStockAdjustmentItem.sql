/* =============================================================================
   Table: dbo.SwStockAdjustmentItem
   Database: SlatwallCommerce
   Slatwall base entity: StockAdjustmentItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockAdjustmentItem] (
    [stockAdjustmentItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [stockAdjustmentID] CHAR(32) NULL,
    [fromStockID] CHAR(32) NULL,
    [toStockID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockAdjustmentItem] PRIMARY KEY CLUSTERED ([stockAdjustmentItemID])
)
GO
