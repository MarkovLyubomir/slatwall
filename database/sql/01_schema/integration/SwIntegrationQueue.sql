/* =============================================================================
   Table: dbo.SwIntegrationQueue
   Database: SlatwallCommerce
   Scheduled file-transfer interfaces (44 of them)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwIntegrationQueue] (
    [IntegrationQueueID] BIGINT IDENTITY(1,1) NOT NULL,
    [InterfaceCode] VARCHAR(20) NOT NULL,
    [Direction] CHAR(3) NOT NULL,
    [FileName] VARCHAR(200) NULL,
    [RecordCount] INT NULL,
    [QueuedOn] DATETIME NOT NULL CONSTRAINT [DF_SwIntegrationQueue_QueuedOn] DEFAULT (GETDATE()),
    [StartedOn] DATETIME NULL,
    [FinishedOn] DATETIME NULL,
    [Status] VARCHAR(12) NOT NULL CONSTRAINT [DF_SwIntegrationQueue_Status] DEFAULT ('QUEUED'),
    [ErrorText] VARCHAR(MAX) NULL,
    [RetryCount] TINYINT NULL CONSTRAINT [DF_SwIntegrationQueue_RetryCount] DEFAULT (0),
    CONSTRAINT [PK_SwIntegrationQueue] PRIMARY KEY CLUSTERED ([IntegrationQueueID])
)
GO
