/* =============================================================================
   Table: dbo.SwWillCallRelease
   Database: SlatwallCommerce
   Job release scheduling against build schedule (O5)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwWillCallRelease] (
    [WillCallReleaseID] INT IDENTITY(1,1) NOT NULL,
    [JobAccountID] INT NOT NULL,
    [orderID] CHAR(32) NOT NULL,
    [ReleaseNo] SMALLINT NOT NULL,
    [ScheduledDate] DATE NOT NULL,
    [ReleaseType] VARCHAR(10) NOT NULL,
    [StoreNumber] TINYINT NULL,
    [ReleasedQtyPct] DECIMAL(5,2) NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwWillCallRelease_Status] DEFAULT ('SCHEDULED'),
    [ReleasedOn] DATETIME NULL,
    [ReleasedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwWillCallRelease] PRIMARY KEY CLUSTERED ([WillCallReleaseID])
)
GO
