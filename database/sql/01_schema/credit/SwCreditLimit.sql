/* =============================================================================
   Table: dbo.SwCreditLimit
   Database: SlatwallCommerce
   Credit limits (account and job level)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCreditLimit] (
    [CreditLimitID] INT IDENTITY(1,1) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [JobAccountID] INT NULL,
    [CreditLimit] DECIMAL(19,2) NOT NULL,
    [TermsCode] VARCHAR(10) NOT NULL CONSTRAINT [DF_SwCreditLimit_TermsCode] DEFAULT ('N30'),
    [EffectiveDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [ApprovedBy] VARCHAR(50) NULL,
    [ApprovalLevel] TINYINT NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwCreditLimit_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwCreditLimit_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwCreditLimit] PRIMARY KEY CLUSTERED ([CreditLimitID])
)
GO
