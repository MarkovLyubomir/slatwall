/* =============================================================================
   Table: dbo.SwStockSnapshot
   Database: SlatwallCommerce
   Nightly stock snapshot (written by usp_Batch_RecalcStock)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStockSnapshot] (
    [StockSnapshotID] BIGINT IDENTITY(1,1) NOT NULL,
    [SnapshotDate] DATE NOT NULL,
    [stockID] CHAR(32) NOT NULL,
    [QOH] INT NULL,
    [QATS] INT NULL,
    [QNC] INT NULL,
    [OnOrder] INT NULL,
    [AvgCost] DECIMAL(19,4) NULL,
    [ExtendedCost] DECIMAL(19,2) NULL,
    CONSTRAINT [PK_SwStockSnapshot] PRIMARY KEY CLUSTERED ([StockSnapshotID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwStockSnapshot_date] ON [dbo].[SwStockSnapshot] ([SnapshotDate])
GO
