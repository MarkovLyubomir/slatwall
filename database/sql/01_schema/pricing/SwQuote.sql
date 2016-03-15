/* =============================================================================
   Table: dbo.SwQuote
   Database: SlatwallCommerce
   Contractor quotes (O5)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwQuote] (
    [QuoteID] INT IDENTITY(1,1) NOT NULL,
    [QuoteNumber] VARCHAR(20) NOT NULL,
    [accountID] CHAR(32) NOT NULL,
    [JobAccountID] INT NULL,
    [StoreNumber] TINYINT NULL,
    [EstimatorUser] VARCHAR(50) NULL,
    [QuoteDate] DATETIME NOT NULL CONSTRAINT [DF_SwQuote_QuoteDate] DEFAULT (GETDATE()),
    [ValidUntil] DATE NULL,
    [QuoteStatus] VARCHAR(12) NOT NULL CONSTRAINT [DF_SwQuote_QuoteStatus] DEFAULT ('DRAFT'),
    [SubTotal] DECIMAL(19,2) NULL,
    [MarginPct] DECIMAL(5,2) NULL,
    [MarginFloorPct] DECIMAL(5,2) NULL,
    [ApprovalLevel] TINYINT NULL,
    [ApprovedBy] VARCHAR(50) NULL,
    [ApprovedOn] DATETIME NULL,
    [TakeoffFileRef] VARCHAR(200) NULL,
    [ConvertedOrderID] CHAR(32) NULL,
    [Notes] VARCHAR(MAX) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwQuote_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwQuote_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwQuote] PRIMARY KEY CLUSTERED ([QuoteID])
)
GO
