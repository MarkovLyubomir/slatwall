/* =============================================================================
   Table: dbo.SwCommodityIndex
   Database: SlatwallCommerce
   Weekly lumber composite index for pass-through pricing
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCommodityIndex] (
    [CommodityIndexID] INT IDENTITY(1,1) NOT NULL,
    [IndexCode] VARCHAR(20) NOT NULL,
    [IndexDate] DATE NOT NULL,
    [IndexValue] DECIMAL(10,2) NOT NULL,
    [Source] VARCHAR(40) NULL,
    [LoadedBy] VARCHAR(50) NULL,
    [LoadedOn] DATETIME NULL CONSTRAINT [DF_SwCommodityIndex_LoadedOn] DEFAULT (GETDATE()),
    CONSTRAINT [PK_SwCommodityIndex] PRIMARY KEY CLUSTERED ([CommodityIndexID])
)
GO
