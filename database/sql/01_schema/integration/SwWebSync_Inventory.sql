/* =============================================================================
   Table: dbo.SwWebSync_Inventory
   Database: SlatwallCommerce
   Adobe Commerce inventory sync staging (availability #2)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwWebSync_Inventory] (
    [WebSyncInventoryID] BIGINT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [StoreNumber] TINYINT NULL,
    [WebQty] INT NULL,
    [QueuedOn] DATETIME NULL CONSTRAINT [DF_SwWebSync_Inventory_QueuedOn] DEFAULT (GETDATE()),
    [SyncedOn] DATETIME NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwWebSync_Inventory_Status] DEFAULT ('PENDING'),
    CONSTRAINT [PK_SwWebSync_Inventory] PRIMARY KEY CLUSTERED ([WebSyncInventoryID])
)
GO
