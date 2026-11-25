/* =============================================================================
   Table: dbo.SwProTierPrice
   Database: SlatwallCommerce
   Pro tier (1-5) pricing rules; overlaps SwPriceGroupRate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProTierPrice] (
    [ProTierPriceID] INT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NULL,
    [productTypeID] CHAR(32) NULL,
    [Tier] TINYINT NOT NULL,
    [DiscountPct] DECIMAL(5,2) NULL,
    [FixedPrice] DECIMAL(19,4) NULL,
    [MarginFloorPct] DECIMAL(5,2) NULL,
    [EffectiveDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwProTierPrice_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwProTierPrice_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwProTierPrice] PRIMARY KEY CLUSTERED ([ProTierPriceID])
)
GO
