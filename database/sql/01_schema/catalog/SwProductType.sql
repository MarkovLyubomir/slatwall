/* =============================================================================
   Table: dbo.SwProductType
   Database: SlatwallCommerce
   Slatwall base entity: ProductType
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProductType] (
    [productTypeID] CHAR(32) NOT NULL,
    [productTypeIDPath] VARCHAR(4000) NULL,
    [activeFlag] BIT NULL,
    [publishedFlag] BIT NULL,
    [urlTitle] VARCHAR(255) NULL,
    [productTypeName] VARCHAR(255) NULL,
    [productTypeDescription] VARCHAR(4000) NULL,
    [systemCode] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [parentProductTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProductType] PRIMARY KEY CLUSTERED ([productTypeID])
)
GO
