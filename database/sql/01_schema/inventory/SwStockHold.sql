/* =============================================================================
   Table: dbo.SwStockHold
   Database: SlatwallCommerce
   Slatwall base entity: StockHold
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockHold] (
    [stockHoldID] CHAR(32) NOT NULL,
    [stockHoldExpirationDateTime] DATETIME NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderItemID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStockHold] PRIMARY KEY CLUSTERED ([stockHoldID])
)
GO
