/* =============================================================================
   Table: dbo.SwTaxCategoryRate
   Database: SlatwallCommerce
   Slatwall base entity: TaxCategoryRate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTaxCategoryRate] (
    [taxCategoryRateID] CHAR(32) NOT NULL,
    [taxRate] FLOAT NULL,
    [taxAddressLookup] VARCHAR(255) NULL,
    [taxCategoryRateCode] VARCHAR(255) NULL,
    [taxLiabilityAppliedToItemFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [addressZoneID] CHAR(32) NULL,
    [taxCategoryID] CHAR(32) NULL,
    [taxIntegrationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwTaxCategoryRate] PRIMARY KEY CLUSTERED ([taxCategoryRateID])
)
GO
