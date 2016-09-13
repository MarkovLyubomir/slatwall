/* =============================================================================
   Table: dbo.SwLienNotice
   Database: SlatwallCommerce
   Preliminary notices, liens, waivers (T6 §6)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLienNotice] (
    [LienNoticeID] INT IDENTITY(1,1) NOT NULL,
    [JobAccountID] INT NOT NULL,
    [NoticeType] VARCHAR(20) NOT NULL,
    [StateCode] CHAR(2) NOT NULL,
    [DeadlineDate] DATE NULL,
    [FiledDate] DATE NULL,
    [FiledBy] VARCHAR(50) NULL,
    [RecordingRef] VARCHAR(40) NULL,
    [WaiverType] VARCHAR(20) NULL,
    [WaiverAmount] DECIMAL(19,2) NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwLienNotice_Status] DEFAULT ('PENDING'),
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwLienNotice_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwLienNotice_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwLienNotice] PRIMARY KEY CLUSTERED ([LienNoticeID])
)
GO
