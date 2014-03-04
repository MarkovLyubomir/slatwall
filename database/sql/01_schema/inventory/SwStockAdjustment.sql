/* =============================================================================
   Table: dbo.SwStockAdjustment
   Database: SlatwallCommerce
   Slatwall base entity: StockAdjustment
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockAdjustment] (
    [stockAdjustmentID] CHAR(32) NOT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [fromLocationID] CHAR(32) NULL,
    [toLocationID] CHAR(32) NULL,
    [stockAdjustmentTypeID] CHAR(32) NULL,
    [stockAdjustmentStatusTypeID] CHAR(32) NULL,
    [physicalID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockAdjustment] PRIMARY KEY CLUSTERED ([stockAdjustmentID])
)
GO
