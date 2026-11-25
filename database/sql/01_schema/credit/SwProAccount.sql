/* =============================================================================
   Table: dbo.SwProAccount
   Database: SlatwallCommerce
   Pro/trade account extension; duplicates SwAccount name/address
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProAccount] (
    [ProAccountID] INT IDENTITY(1,1) NOT NULL,
    [accountID] CHAR(32) NOT NULL,
    [BTCustomerNo] VARCHAR(20) NULL,
    [CompanyName] VARCHAR(120) NULL,
    [TradeType] VARCHAR(30) NULL,
    [Tier] TINYINT NOT NULL CONSTRAINT [DF_SwProAccount_Tier] DEFAULT (5),
    [TierEffectiveDate] DATE NULL,
    [TTMPurchases] DECIMAL(19,2) NULL CONSTRAINT [DF_SwProAccount_TTMPurchases] DEFAULT (0),
    [PrevTTMPurchases] DECIMAL(19,2) NULL,
    [SalesRepUser] VARCHAR(50) NULL,
    [Territory] VARCHAR(20) NULL,
    [HomeStoreNumber] TINYINT NULL,
    [RebatePct] DECIMAL(5,2) NULL,
    [ProRewardsFlag] BIT NULL CONSTRAINT [DF_SwProAccount_ProRewardsFlag] DEFAULT (0),
    [BillingAddress1] VARCHAR(100) NULL,
    [BillingCity] VARCHAR(40) NULL,
    [BillingState] CHAR(2) NULL,
    [BillingZip] VARCHAR(10) NULL,
    [Phone] VARCHAR(20) NULL,
    [SFDCAccountId] VARCHAR(18) NULL,
    [ActiveFlag] BIT NOT NULL CONSTRAINT [DF_SwProAccount_ActiveFlag] DEFAULT (1),
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwProAccount_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwProAccount_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwProAccount] PRIMARY KEY CLUSTERED ([ProAccountID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwProAccount_accountID] ON [dbo].[SwProAccount] ([accountID])
GO

CREATE NONCLUSTERED INDEX [IX_SwProAccount_BTCustomerNo] ON [dbo].[SwProAccount] ([BTCustomerNo])
GO
