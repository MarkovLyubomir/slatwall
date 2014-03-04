/* =============================================================================
   Table: dbo.SwStockReceiver
   Database: SlatwallCommerce
   Slatwall base entity: StockReceiver
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockReceiver] (
    [stockReceiverID] CHAR(32) NOT NULL,
    [packingSlipNumber] VARCHAR(255) NULL,
    [boxCount] INT NULL,
    [receiverType] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderID] CHAR(32) NULL,
    [stockAdjustmentID] CHAR(32) NULL,
    [vendorOrderID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockReceiver] PRIMARY KEY CLUSTERED ([stockReceiverID])
)
GO
