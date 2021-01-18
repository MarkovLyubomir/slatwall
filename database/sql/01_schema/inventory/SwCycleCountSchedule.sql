/* =============================================================================
   Table: dbo.SwCycleCountSchedule
   Database: SlatwallCommerce
   ABC/XYZ cycle-count cadence (T4, O3)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCycleCountSchedule] (
    [CycleCountScheduleID] INT IDENTITY(1,1) NOT NULL,
    [locationID] CHAR(32) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [ABCClass] CHAR(1) NOT NULL,
    [XYZClass] CHAR(1) NULL,
    [FrequencyDays] SMALLINT NOT NULL,
    [LastCountedOn] DATE NULL,
    [NextDueOn] DATE NULL,
    [Priority] TINYINT NULL CONSTRAINT [DF_SwCycleCountSchedule_Priority] DEFAULT (3),
    CONSTRAINT [PK_SwCycleCountSchedule] PRIMARY KEY CLUSTERED ([CycleCountScheduleID])
)
GO
