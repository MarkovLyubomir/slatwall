/* =============================================================================
   Table: dbo.SwCountry
   Database: SlatwallCommerce
   Slatwall base entity: Country
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCountry] (
    [countryCode] CHAR(32) NOT NULL,
    [countryCode3Digit] VARCHAR(3) NULL,
    [countryISONumber] INT NULL,
    [countryName] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [streetAddressLabel] VARCHAR(255) NULL,
    [streetAddressShowFlag] BIT NULL,
    [streetAddressRequiredFlag] BIT NULL,
    [street2AddressLabel] VARCHAR(255) NULL,
    [street2AddressShowFlag] BIT NULL,
    [street2AddressRequiredFlag] BIT NULL,
    [localityLabel] VARCHAR(255) NULL,
    [localityShowFlag] BIT NULL,
    [localityRequiredFlag] BIT NULL,
    [cityLabel] VARCHAR(255) NULL,
    [cityShowFlag] BIT NULL,
    [cityRequiredFlag] BIT NULL,
    [stateCodeLabel] VARCHAR(255) NULL,
    [stateCodeShowFlag] BIT NULL,
    [stateCodeRequiredFlag] BIT NULL,
    [postalCodeLabel] VARCHAR(255) NULL,
    [postalCodeShowFlag] BIT NULL,
    [postalCodeRequiredFlag] BIT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [defaultCurrencyCode] CHAR(32) NULL,
    CONSTRAINT [PK_SwCountry] PRIMARY KEY CLUSTERED ([countryCode])
)
GO
