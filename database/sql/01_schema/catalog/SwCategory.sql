/* =============================================================================
   Table: dbo.SwCategory
   Database: SlatwallCommerce
   Slatwall base entity: Category
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCategory] (
    [categoryID] CHAR(32) NOT NULL,
    [categoryIDPath] VARCHAR(4000) NULL,
    [categoryName] VARCHAR(255) NULL,
    [categoryDescription] VARCHAR(4000) NULL,
    [urlTitle] VARCHAR(255) NULL,
    [restrictAccessFlag] BIT NULL,
    [allowProductAssignmentFlag] BIT NULL,
    [cmsCategoryID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [siteID] CHAR(32) NULL,
    [parentCategoryID] CHAR(32) NULL,
    CONSTRAINT [PK_SwCategory] PRIMARY KEY CLUSTERED ([categoryID])
)
GO

-- NOTE: [siteID] references the former SwSite table (dropped 2017); column retained.