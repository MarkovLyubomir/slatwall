/* =============================================================================
   Table: dbo.SwItemMaster_BT
   Database: SlatwallCommerce
   Nightly copy of BisTrack item master (second catalog)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwItemMaster_BT] (
    [ItemNo] VARCHAR(30) NOT NULL,
    [ItemDesc] VARCHAR(120) NULL,
    [UOM] VARCHAR(8) NULL,
    [VendorNo] VARCHAR(20) NULL,
    [StdCost] DECIMAL(19,4) NULL,
    [AvgCost] DECIMAL(19,4) NULL,
    [ListPrice] DECIMAL(19,4) NULL,
    [TaxClass] VARCHAR(10) NULL,
    [ProductGroup] VARCHAR(20) NULL,
    [CommodityFlag] BIT NULL CONSTRAINT [DF_SwItemMaster_BT_CommodityFlag] DEFAULT (0),
    [PrivateLabelCode] VARCHAR(10) NULL,
    [Weight] DECIMAL(10,3) NULL,
    [LengthFt] DECIMAL(6,2) NULL,
    [BTLastChanged] DATETIME NULL,
    [LoadedOn] DATETIME NULL CONSTRAINT [DF_SwItemMaster_BT_LoadedOn] DEFAULT (GETDATE()),
    CONSTRAINT [PK_SwItemMaster_BT] PRIMARY KEY CLUSTERED ([ItemNo])
)
GO
