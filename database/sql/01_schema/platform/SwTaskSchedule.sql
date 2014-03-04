/* =============================================================================
   Table: dbo.SwTaskSchedule
   Database: SlatwallCommerce
   Slatwall base entity: TaskSchedule
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTaskSchedule] (
    [taskScheduleID] CHAR(32) NOT NULL,
    [startDateTime] DATETIME NULL,
    [endDateTime] DATETIME NULL,
    [nextRunDateTime] DATETIME NULL,
    [failureEmailList] VARCHAR(255) NULL,
    [successEmailList] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [scheduleID] CHAR(32) NULL,
    [taskID] CHAR(32) NULL,
    CONSTRAINT [PK_SwTaskSchedule] PRIMARY KEY CLUSTERED ([taskScheduleID])
)
GO

-- NOTE: [scheduleID] references the former SwSchedule table (dropped 2017); column retained.