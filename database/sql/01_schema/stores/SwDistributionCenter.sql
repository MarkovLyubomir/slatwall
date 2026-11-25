/* =============================================================================
   Table: dbo.SwDistributionCenter
   Database: SlatwallCommerce
   DC master (KNV primary, CAE satellite)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwDistributionCenter] (
    [DCID] INT IDENTITY(1,1) NOT NULL,
    [DCCode] CHAR(3) NOT NULL,
    [DCName] VARCHAR(60) NOT NULL,
    [locationID] CHAR(32) NULL,
    [SquareFeet] INT NULL,
    [PrimaryFlag] BIT NOT NULL CONSTRAINT [DF_SwDistributionCenter_PrimaryFlag] DEFAULT (0),
    [WMSSystem] VARCHAR(30) NULL,
    [CutoffTime] TIME NULL,
    CONSTRAINT [PK_SwDistributionCenter] PRIMARY KEY CLUSTERED ([DCID])
)
GO
