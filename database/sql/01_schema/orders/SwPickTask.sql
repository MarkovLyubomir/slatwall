/* =============================================================================
   Table: dbo.SwPickTask
   Database: SlatwallCommerce
   BOPIS / curbside / will-call pick-pack-stage (O2)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPickTask] (
    [PickTaskID] INT IDENTITY(1,1) NOT NULL,
    [orderFulfillmentID] CHAR(32) NOT NULL,
    [StoreNumber] TINYINT NOT NULL,
    [FulfillType] VARCHAR(10) NOT NULL,
    [PickStatus] VARCHAR(12) NOT NULL CONSTRAINT [DF_SwPickTask_PickStatus] DEFAULT ('NEW'),
    [AssignedTo] VARCHAR(50) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwPickTask_CreatedOn] DEFAULT (GETDATE()),
    [SLADueOn] DATETIME NULL,
    [PickStartedOn] DATETIME NULL,
    [PickCompletedOn] DATETIME NULL,
    [StagedOn] DATETIME NULL,
    [StagingBay] VARCHAR(10) NULL,
    [CustomerNotifiedOn] DATETIME NULL,
    [PickedUpOn] DATETIME NULL,
    [VerifiedIDType] VARCHAR(20) NULL,
    [PartialFlag] BIT NULL CONSTRAINT [DF_SwPickTask_PartialFlag] DEFAULT (0),
    [AbandonedOn] DATETIME NULL,
    [LineCount] SMALLINT NULL,
    [ShortLineCount] SMALLINT NULL,
    CONSTRAINT [PK_SwPickTask] PRIMARY KEY CLUSTERED ([PickTaskID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwPickTask_Store_Status] ON [dbo].[SwPickTask] ([StoreNumber], [PickStatus])
GO
