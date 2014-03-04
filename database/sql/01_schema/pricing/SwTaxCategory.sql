/* =============================================================================
   Table: dbo.SwTaxCategory
   Database: SlatwallCommerce
   Slatwall base entity: TaxCategory
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTaxCategory] (
    [taxCategoryID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [taxCategoryName] VARCHAR(255) NULL,
    [taxCategoryCode] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwTaxCategory] PRIMARY KEY CLUSTERED ([taxCategoryID])
)
GO
