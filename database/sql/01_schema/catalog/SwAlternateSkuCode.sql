/* =============================================================================
   Table: dbo.SwAlternateSkuCode
   Database: SlatwallCommerce
   Slatwall base entity: AlternateSkuCode
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAlternateSkuCode] (
    [alternateSkuCodeID] CHAR(32) NOT NULL,
    [alternateSkuCode] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [skuTypeID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAlternateSkuCode] PRIMARY KEY CLUSTERED ([alternateSkuCodeID])
)
GO
