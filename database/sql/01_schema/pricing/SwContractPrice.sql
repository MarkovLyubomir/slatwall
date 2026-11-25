/* =============================================================================
   Table: dbo.SwContractPrice
   Database: SlatwallCommerce
   Customer-specific contract pricing
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwContractPrice] (
    [ContractPriceID] INT IDENTITY(1,1) NOT NULL,
    [accountID] CHAR(32) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [ContractPrice] DECIMAL(19,4) NOT NULL,
    [JobAccountID] INT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [ApprovedBy] VARCHAR(50) NULL,
    [ContractRef] VARCHAR(40) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwContractPrice_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwContractPrice_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwContractPrice] PRIMARY KEY CLUSTERED ([ContractPriceID])
)
GO
