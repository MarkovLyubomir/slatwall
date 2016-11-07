/* =============================================================================
   Table: dbo.SwLocationZone
   Database: SlatwallCommerce
   Price/delivery zone per location (T2 zone pricing)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLocationZone] (
    [LocationZoneID] INT IDENTITY(1,1) NOT NULL,
    [locationID] CHAR(32) NOT NULL,
    [PriceZone] CHAR(1) NOT NULL,
    [DeliveryZone] VARCHAR(10) NULL,
    [TaxJurisdiction] VARCHAR(20) NULL,
    [EffectiveDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    CONSTRAINT [PK_SwLocationZone] PRIMARY KEY CLUSTERED ([LocationZoneID])
)
GO
