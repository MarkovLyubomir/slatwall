/* =============================================================================
   Table: dbo.SwEDIMessage
   Database: SlatwallCommerce
   EDI 850/855/856/810 staging (VAN file drop)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwEDIMessage] (
    [EDIMessageID] BIGINT IDENTITY(1,1) NOT NULL,
    [Direction] CHAR(3) NOT NULL,
    [TransactionSet] CHAR(3) NOT NULL,
    [TradingPartner] VARCHAR(20) NOT NULL,
    [ControlNumber] VARCHAR(20) NULL,
    [ReceivedOn] DATETIME NULL CONSTRAINT [DF_SwEDIMessage_ReceivedOn] DEFAULT (GETDATE()),
    [ProcessedOn] DATETIME NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwEDIMessage_Status] DEFAULT ('NEW'),
    [RawPayload] VARCHAR(MAX) NULL,
    [ErrorText] VARCHAR(500) NULL,
    [RelatedRef] VARCHAR(40) NULL,
    CONSTRAINT [PK_SwEDIMessage] PRIMARY KEY CLUSTERED ([EDIMessageID])
)
GO
