/* =============================================================================
   Table: dbo.SwStockAdjustmentDelivery
   Database: SlatwallCommerce
   Slatwall base entity: StockAdjustmentDelivery
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockAdjustmentDelivery] (
    [stockAdjustmentDeliveryID] CHAR(32) NOT NULL,
    [deliveryOpenDateTime] DATETIME NULL,
    [deliveryCloseDateTime] DATETIME NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [stockAdjustmentID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockAdjustmentDelivery] PRIMARY KEY CLUSTERED ([stockAdjustmentDeliveryID])
)
GO
