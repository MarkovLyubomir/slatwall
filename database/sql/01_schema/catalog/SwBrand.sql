/* =============================================================================
   Table: dbo.SwBrand
   Database: SlatwallCommerce
   Slatwall base entity: Brand
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwBrand] (
    [brandID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [publishedFlag] BIT NULL,
    [urlTitle] VARCHAR(255) NULL,
    [brandName] VARCHAR(255) NULL,
    [brandWebsite] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwBrand] PRIMARY KEY CLUSTERED ([brandID])
)
GO
