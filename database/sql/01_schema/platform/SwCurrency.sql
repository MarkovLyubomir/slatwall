/* =============================================================================
   Table: dbo.SwCurrency
   Database: SlatwallCommerce
   Slatwall base entity: Currency
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCurrency] (
    [currencyCode] CHAR(32) NOT NULL,
    [currencyISONumber] INT NULL,
    [activeFlag] BIT NULL,
    [currencyName] VARCHAR(255) NULL,
    [currencySymbol] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwCurrency] PRIMARY KEY CLUSTERED ([currencyCode])
)
GO
