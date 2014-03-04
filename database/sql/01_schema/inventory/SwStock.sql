/* =============================================================================
   Table: dbo.SwStock
   Database: SlatwallCommerce
   Slatwall base entity: Stock
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStock] (
    [stockID] CHAR(32) NOT NULL,
    [calculatedQATS] INT NULL,
    [calculatedQOH] INT NULL,
    [calculatedQNC] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwStock] PRIMARY KEY CLUSTERED ([stockID])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_SwStock_sku_location] ON [dbo].[SwStock] ([skuID], [locationID])
GO
