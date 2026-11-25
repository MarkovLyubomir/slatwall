/* =============================================================================
   Table: dbo.SwDunningEvent
   Database: SlatwallCommerce
   Five-stage dunning sequence (T6 §7.3)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwDunningEvent] (
    [DunningEventID] INT IDENTITY(1,1) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [Stage] TINYINT NOT NULL,
    [EventDate] DATE NOT NULL,
    [PastDueAmount] DECIMAL(19,2) NULL,
    [OldestInvoiceDays] SMALLINT NULL,
    [Channel] VARCHAR(10) NULL,
    [SentBy] VARCHAR(50) NULL,
    [BilltrustRef] VARCHAR(40) NULL,
    CONSTRAINT [PK_SwDunningEvent] PRIMARY KEY CLUSTERED ([DunningEventID])
)
GO
