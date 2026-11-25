/* =============================================================================
   Table: dbo.SwKPI_Snapshot
   Database: SlatwallCommerce
   Weekly KPI snapshot (O6)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwKPI_Snapshot] (
    [KPISnapshotID] INT IDENTITY(1,1) NOT NULL,
    [FiscalYear] SMALLINT NOT NULL,
    [FiscalWeek] TINYINT NOT NULL,
    [StoreNumber] TINYINT NULL,
    [Channel] VARCHAR(10) NULL,
    [KPICode] VARCHAR(30) NOT NULL,
    [KPIValue] DECIMAL(19,4) NULL,
    [PlanValue] DECIMAL(19,4) NULL,
    [CalcVersion] VARCHAR(10) NULL,
    [CalculatedOn] DATETIME NULL CONSTRAINT [DF_SwKPI_Snapshot_CalculatedOn] DEFAULT (GETDATE()),
    CONSTRAINT [PK_SwKPI_Snapshot] PRIMARY KEY CLUSTERED ([KPISnapshotID])
)
GO
