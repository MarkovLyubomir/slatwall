/* =============================================================================
   Table: dbo.SwCurrencyRate
   Database: SlatwallCommerce
   Slatwall base entity: CurrencyRate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCurrencyRate] (
    [currencyRateID] CHAR(32) NOT NULL,
    [conversionRate] FLOAT NULL,
    [effectiveStartDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [currencyCode] CHAR(32) NULL,
    [conversionCurrencyCode] CHAR(32) NULL,
    CONSTRAINT [PK_SwCurrencyRate] PRIMARY KEY CLUSTERED ([currencyRateID])
)
GO
