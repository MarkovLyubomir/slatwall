/* =============================================================================
   Table: dbo.SwCreditApplication
   Database: SlatwallCommerce
   Credit applications (T6 §5.1)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCreditApplication] (
    [CreditApplicationID] INT IDENTITY(1,1) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [AppDate] DATE NOT NULL,
    [RequestedLimit] DECIMAL(19,2) NULL,
    [BureauScore] SMALLINT NULL,
    [TradeRefCount] TINYINT NULL,
    [PersonalGuaranteeFlag] BIT NULL CONSTRAINT [DF_SwCreditApplication_PersonalGuaranteeFlag] DEFAULT (0),
    [CorporateGuaranteeFlag] BIT NULL CONSTRAINT [DF_SwCreditApplication_CorporateGuaranteeFlag] DEFAULT (0),
    [Decision] VARCHAR(12) NULL,
    [DecisionBy] VARCHAR(50) NULL,
    [DecisionDate] DATE NULL,
    [ApprovedLimit] DECIMAL(19,2) NULL,
    [TermsCode] VARCHAR(10) NULL,
    [Notes] VARCHAR(MAX) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwCreditApplication_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwCreditApplication_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwCreditApplication] PRIMARY KEY CLUSTERED ([CreditApplicationID])
)
GO
