/* =============================================================================
   Table: dbo.SwZonePrice
   Database: SlatwallCommerce
   Zone price by SKU (T2)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwZonePrice] (
    [ZonePriceID] INT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [PriceZone] CHAR(1) NOT NULL,
    [ZonePrice] DECIMAL(19,4) NOT NULL,
    [EffectiveDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [SourceSystem] VARCHAR(10) NULL CONSTRAINT [DF_SwZonePrice_SourceSystem] DEFAULT ('BT'),
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwZonePrice_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwZonePrice_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwZonePrice] PRIMARY KEY CLUSTERED ([ZonePriceID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwZonePrice_sku_zone] ON [dbo].[SwZonePrice] ([skuID], [PriceZone], [EffectiveDate])
GO
