/* =============================================================================
   Table: dbo.SwJobAccount
   Database: SlatwallCommerce
   Per-job billing accounts (T6 §4)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwJobAccount] (
    [JobAccountID] INT IDENTITY(1,1) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [JobNumber] VARCHAR(20) NOT NULL,
    [JobName] VARCHAR(120) NULL,
    [JobAddress1] VARCHAR(100) NULL,
    [JobCity] VARCHAR(40) NULL,
    [JobState] CHAR(2) NULL,
    [JobZip] VARCHAR(10) NULL,
    [JobCounty] VARCHAR(40) NULL,
    [OwnerName] VARCHAR(120) NULL,
    [GCName] VARCHAR(120) NULL,
    [JobBudget] DECIMAL(19,2) NULL,
    [JobStartDate] DATE NULL,
    [ExpectedCloseDate] DATE NULL,
    [FirstDeliveryDate] DATE NULL,
    [NTODeadline] DATE NULL,
    [NTOFiledDate] DATE NULL,
    [LienDeadline] DATE NULL,
    [PublicWorkFlag] BIT NULL CONSTRAINT [DF_SwJobAccount_PublicWorkFlag] DEFAULT (0),
    [BondedFlag] BIT NULL CONSTRAINT [DF_SwJobAccount_BondedFlag] DEFAULT (0),
    [JobStatus] VARCHAR(12) NOT NULL CONSTRAINT [DF_SwJobAccount_JobStatus] DEFAULT ('OPEN'),
    [ClosedDate] DATE NULL,
    [BTJobNo] VARCHAR(20) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwJobAccount_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwJobAccount_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwJobAccount] PRIMARY KEY CLUSTERED ([JobAccountID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwJobAccount_ProAccountID] ON [dbo].[SwJobAccount] ([ProAccountID])
GO
