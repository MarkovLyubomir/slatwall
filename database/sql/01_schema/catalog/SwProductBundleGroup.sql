/* =============================================================================
   Table: dbo.SwProductBundleGroup
   Database: SlatwallCommerce
   Slatwall base entity: ProductBundleGroup
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProductBundleGroup] (
    [productBundleGroupID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [minimumQuantity] INT NULL,
    [maximumQuantity] INT NULL,
    [amountType] VARCHAR(255) NULL,
    [amount] DECIMAL(19,2) NULL,
    [skuCollectionConfig] VARCHAR(MAX) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [productBundleSkuID] CHAR(32) NULL,
    [productBundleGroupTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProductBundleGroup] PRIMARY KEY CLUSTERED ([productBundleGroupID])
)
GO
