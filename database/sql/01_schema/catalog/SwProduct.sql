/* =============================================================================
   Table: dbo.SwProduct
   Database: SlatwallCommerce
   Slatwall base entity: Product
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProduct] (
    [productID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [urlTitle] VARCHAR(255) NULL,
    [productName] VARCHAR(255) NULL,
    [productCode] VARCHAR(255) NULL,
    [productDescription] VARCHAR(4000) NULL,
    [publishedFlag] BIT NULL,
    [sortOrder] INT NULL,
    [purchaseStartDateTime] DATETIME NULL,
    [purchaseEndDateTime] DATETIME NULL,
    [calculatedSalePrice] DECIMAL(19,2) NULL,
    [calculatedQATS] INT NULL,
    [calculatedAllowBackorderFlag] BIT NULL,
    [calculatedTitle] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [brandID] CHAR(32) NULL,
    [productTypeID] CHAR(32) NULL,
    [defaultSkuID] CHAR(32) NULL,
    [renewalSkuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProduct] PRIMARY KEY CLUSTERED ([productID])
)
GO
