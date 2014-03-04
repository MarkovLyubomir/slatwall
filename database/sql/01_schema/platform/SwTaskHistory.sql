/* =============================================================================
   Table: dbo.SwTaskHistory
   Database: SlatwallCommerce
   Slatwall base entity: TaskHistory
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTaskHistory] (
    [taskHistoryID] CHAR(32) NOT NULL,
    [successFlag] BIT NULL,
    [response] VARCHAR(255) NULL,
    [startTime] DATETIME NULL,
    [endTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [taskID] CHAR(32) NULL,
    [taskScheduleID] CHAR(32) NULL,
    CONSTRAINT [PK_SwTaskHistory] PRIMARY KEY CLUSTERED ([taskHistoryID])
)
GO
