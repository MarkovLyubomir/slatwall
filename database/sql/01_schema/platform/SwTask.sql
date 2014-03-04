/* =============================================================================
   Table: dbo.SwTask
   Database: SlatwallCommerce
   Slatwall base entity: Task
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTask] (
    [taskID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [taskName] VARCHAR(255) NULL,
    [taskMethod] VARCHAR(255) NULL,
    [taskUrl] VARCHAR(255) NULL,
    [taskConfig] VARCHAR(4000) NULL,
    [runningFlag] BIT NULL,
    [timeout] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwTask] PRIMARY KEY CLUSTERED ([taskID])
)
GO
