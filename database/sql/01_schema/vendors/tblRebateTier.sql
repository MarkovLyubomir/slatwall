/* =============================================================================
   Table: dbo.tblRebateTier
   Database: SlatwallCommerce
   LEGACY: rebate tiers (Access); RebateID has no FK
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRebateTier] (
    [TierID] INT IDENTITY(1,1) NOT NULL,
    [RebateID] INT NULL,
    [TierFrom] MONEY NULL,
    [TierTo] MONEY NULL,
    [RebatePct] FLOAT NULL,
    [Growth] BIT NULL,
    CONSTRAINT [PK_tblRebateTier] PRIMARY KEY CLUSTERED ([TierID])
)
GO
