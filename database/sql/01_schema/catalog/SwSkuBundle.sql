/* =============================================================================
   Table: dbo.SwSkuBundle
   Database: SlatwallCommerce
   Slatwall base entity: SkuBundle
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSkuBundle] (
    [skuBundleID] CHAR(32) NOT NULL,
    [bundledQuantity] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [skuID] CHAR(32) NULL,
    [bundledSkuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwSkuBundle] PRIMARY KEY CLUSTERED ([skuBundleID])
)
GO
