/* =============================================================================
   Table: dbo.SwWebSync_Price
   Database: SlatwallCommerce
   Adobe Commerce price sync staging (price book #2)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwWebSync_Price] (
    [WebSyncPriceID] BIGINT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [PriceZone] CHAR(1) NULL,
    [CustomerGroup] VARCHAR(20) NULL,
    [WebPrice] DECIMAL(19,4) NULL,
    [QueuedOn] DATETIME NULL CONSTRAINT [DF_SwWebSync_Price_QueuedOn] DEFAULT (GETDATE()),
    [SyncedOn] DATETIME NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwWebSync_Price_Status] DEFAULT ('PENDING'),
    CONSTRAINT [PK_SwWebSync_Price] PRIMARY KEY CLUSTERED ([WebSyncPriceID])
)
GO
