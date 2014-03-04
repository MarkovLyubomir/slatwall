/* =============================================================================
   Table: dbo.SwProductBundleBuildItem
   Database: SlatwallCommerce
   Slatwall base entity: ProductBundleBuildItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProductBundleBuildItem] (
    [productBundleBuildItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [productBundleBuildID] CHAR(32) NULL,
    [productBundleGroupID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProductBundleBuildItem] PRIMARY KEY CLUSTERED ([productBundleBuildItemID])
)
GO
