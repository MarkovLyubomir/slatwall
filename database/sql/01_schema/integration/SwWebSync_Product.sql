/* =============================================================================
   Table: dbo.SwWebSync_Product
   Database: SlatwallCommerce
   Adobe Commerce product sync staging
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwWebSync_Product] (
    [WebSyncProductID] BIGINT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [AdobeSku] VARCHAR(64) NULL,
    [AdobeProductId] INT NULL,
    [Payload] VARCHAR(MAX) NULL,
    [Action] VARCHAR(10) NULL,
    [QueuedOn] DATETIME NULL CONSTRAINT [DF_SwWebSync_Product_QueuedOn] DEFAULT (GETDATE()),
    [SyncedOn] DATETIME NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwWebSync_Product_Status] DEFAULT ('PENDING'),
    [ErrorText] VARCHAR(500) NULL,
    CONSTRAINT [PK_SwWebSync_Product] PRIMARY KEY CLUSTERED ([WebSyncProductID])
)
GO
