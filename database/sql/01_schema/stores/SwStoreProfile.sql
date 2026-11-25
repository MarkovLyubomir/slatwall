/* =============================================================================
   Table: dbo.SwStoreProfile
   Database: SlatwallCommerce
   Store master (store 01-14); duplicates SwLocation
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStoreProfile] (
    [StoreProfileID] INT IDENTITY(1,1) NOT NULL,
    [StoreNumber] TINYINT NOT NULL,
    [locationID] CHAR(32) NULL,
    [StoreName] VARCHAR(60) NOT NULL,
    [City] VARCHAR(40) NULL,
    [StateCode] CHAR(2) NULL,
    [Region] VARCHAR(20) NOT NULL,
    [RegionalDirector] VARCHAR(60) NULL,
    [OpenDate] DATE NULL,
    [YardFlag] BIT NOT NULL CONSTRAINT [DF_SwStoreProfile_YardFlag] DEFAULT (1),
    [ProDeskFlag] BIT NOT NULL CONSTRAINT [DF_SwStoreProfile_ProDeskFlag] DEFAULT (1),
    [BoomTruckCount] TINYINT NULL CONSTRAINT [DF_SwStoreProfile_BoomTruckCount] DEFAULT (0),
    [PriceZone] CHAR(1) NULL,
    [SquareFeet] INT NULL,
    [ActiveFlag] BIT NOT NULL CONSTRAINT [DF_SwStoreProfile_ActiveFlag] DEFAULT (1),
    CONSTRAINT [PK_SwStoreProfile] PRIMARY KEY CLUSTERED ([StoreProfileID])
)
GO
