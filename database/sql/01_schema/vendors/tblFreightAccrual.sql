/* =============================================================================
   Table: dbo.tblFreightAccrual
   Database: SlatwallCommerce
   LEGACY: imported from FreightAccrual.accdb
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblFreightAccrual] (
    [AccrualID] INT IDENTITY(1,1) NOT NULL,
    [PeriodYYYYMM] CHAR(6) NULL,
    [Carrier] VARCHAR(60) NULL,
    [DC] VARCHAR(5) NULL,
    [Lane] VARCHAR(40) NULL,
    [EstFreight] MONEY NULL,
    [ActualFreight] MONEY NULL,
    [Variance] MONEY NULL,
    [Posted] BIT NULL,
    [PostedDate] DATETIME NULL,
    [GLAcct] VARCHAR(12) NULL,
    [Comments] VARCHAR(MAX) NULL,
    CONSTRAINT [PK_tblFreightAccrual] PRIMARY KEY CLUSTERED ([AccrualID])
)
GO
