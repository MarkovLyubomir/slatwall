/* =============================================================================
   Table: dbo.SwTaxApplied
   Database: SlatwallCommerce
   Slatwall base entity: TaxApplied
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTaxApplied] (
    [taxAppliedID] CHAR(32) NOT NULL,
    [taxAmount] DECIMAL(19,2) NULL,
    [taxLiabilityAmount] DECIMAL(19,2) NULL,
    [taxRate] DECIMAL(19,2) NULL,
    [appliedType] VARCHAR(255) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [taxStreetAddress] VARCHAR(255) NULL,
    [taxStreet2Address] VARCHAR(255) NULL,
    [taxLocality] VARCHAR(255) NULL,
    [taxCity] VARCHAR(255) NULL,
    [taxStateCode] VARCHAR(255) NULL,
    [taxPostalCode] VARCHAR(255) NULL,
    [taxCountryCode] VARCHAR(255) NULL,
    [taxImpositionID] VARCHAR(255) NULL,
    [taxImpositionName] VARCHAR(255) NULL,
    [taxImpositionType] VARCHAR(255) NULL,
    [taxJurisdictionID] VARCHAR(255) NULL,
    [taxJurisdictionName] VARCHAR(255) NULL,
    [taxJurisdictionType] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [taxCategoryRateID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    CONSTRAINT [PK_SwTaxApplied] PRIMARY KEY CLUSTERED ([taxAppliedID])
)
GO
