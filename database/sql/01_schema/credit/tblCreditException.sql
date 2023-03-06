/* =============================================================================
   Table: dbo.tblCreditException
   Database: SlatwallCommerce
   LEGACY: imported from CreditExceptions.accdb (Access) - no keys, no FKs
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCreditException] (
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CustNo] VARCHAR(20) NULL,
    [CustName] VARCHAR(100) NULL,
    [ExcDate] DATETIME NULL,
    [ExcType] VARCHAR(30) NULL,
    [Amt] MONEY NULL,
    [ApprovedBy] VARCHAR(30) NULL,
    [Store] VARCHAR(5) NULL,
    [Memo] VARCHAR(MAX) NULL,
    [Resolved] BIT NULL,
    [ResolvedDate] DATETIME NULL,
    [EnteredBy] VARCHAR(30) NULL,
    CONSTRAINT [PK_tblCreditException] PRIMARY KEY CLUSTERED ([ID])
)
GO
