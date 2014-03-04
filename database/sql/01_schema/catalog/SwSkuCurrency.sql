/* =============================================================================
   Table: dbo.SwSkuCurrency
   Database: SlatwallCommerce
   Slatwall base entity: SkuCurrency
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSkuCurrency] (
    [skuCurrencyID] CHAR(32) NOT NULL,
    [price] DECIMAL(19,2) NULL,
    [renewalPrice] DECIMAL(19,2) NULL,
    [listPrice] DECIMAL(19,2) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [currencyCode] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwSkuCurrency] PRIMARY KEY CLUSTERED ([skuCurrencyID])
)
GO
