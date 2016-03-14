/* =============================================================================
   Table: dbo.SwQuoteLine
   Database: SlatwallCommerce
   Quote lines
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwQuoteLine] (
    [QuoteLineID] INT IDENTITY(1,1) NOT NULL,
    [QuoteID] INT NOT NULL,
    [LineNo] SMALLINT NOT NULL,
    [skuID] CHAR(32) NULL,
    [ItemNo] VARCHAR(30) NULL,
    [Description] VARCHAR(200) NULL,
    [Qty] DECIMAL(12,3) NOT NULL,
    [UOM] VARCHAR(8) NULL,
    [UnitCost] DECIMAL(19,4) NULL,
    [UnitPrice] DECIMAL(19,4) NULL,
    [LineMarginPct] DECIMAL(5,2) NULL,
    [CommodityFlag] BIT NULL CONSTRAINT [DF_SwQuoteLine_CommodityFlag] DEFAULT (0),
    [SpecialOrderFlag] BIT NULL CONSTRAINT [DF_SwQuoteLine_SpecialOrderFlag] DEFAULT (0),
    [CutFlag] BIT NULL CONSTRAINT [DF_SwQuoteLine_CutFlag] DEFAULT (0),
    CONSTRAINT [PK_SwQuoteLine] PRIMARY KEY CLUSTERED ([QuoteLineID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwQuoteLine_QuoteID] ON [dbo].[SwQuoteLine] ([QuoteID])
GO
