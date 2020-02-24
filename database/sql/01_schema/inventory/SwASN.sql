/* =============================================================================
   Table: dbo.SwASN
   Database: SlatwallCommerce
   EDI 856 advance ship notices
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwASN] (
    [ASNID] INT IDENTITY(1,1) NOT NULL,
    [ASNNumber] VARCHAR(30) NOT NULL,
    [vendorID] CHAR(32) NULL,
    [vendorOrderID] CHAR(32) NULL,
    [PONumber] VARCHAR(20) NULL,
    [ShipDate] DATE NULL,
    [ExpectedDate] DATE NULL,
    [DCCode] CHAR(3) NULL,
    [Carrier] VARCHAR(40) NULL,
    [BOLNumber] VARCHAR(30) NULL,
    [LineCount] SMALLINT NULL,
    [EDIRawRef] VARCHAR(200) NULL,
    [ReceivedOn] DATETIME NOT NULL CONSTRAINT [DF_SwASN_ReceivedOn] DEFAULT (GETDATE()),
    [MatchStatus] VARCHAR(12) NULL CONSTRAINT [DF_SwASN_MatchStatus] DEFAULT ('UNMATCHED'),
    CONSTRAINT [PK_SwASN] PRIMARY KEY CLUSTERED ([ASNID])
)
GO
