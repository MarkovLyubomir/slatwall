/* =============================================================================
   Table: dbo.SwETL_Log
   Database: SlatwallCommerce
   Batch/ETL log
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwETL_Log] (
    [ETLLogID] BIGINT IDENTITY(1,1) NOT NULL,
    [JobName] VARCHAR(60) NOT NULL,
    [StepName] VARCHAR(60) NULL,
    [StartedOn] DATETIME NOT NULL CONSTRAINT [DF_SwETL_Log_StartedOn] DEFAULT (GETDATE()),
    [FinishedOn] DATETIME NULL,
    [RowsAffected] INT NULL,
    [Status] VARCHAR(12) NULL,
    [Message] VARCHAR(MAX) NULL,
    [RunBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwETL_Log] PRIMARY KEY CLUSTERED ([ETLLogID])
)
GO
