/* =============================================================================
   Table: dbo.SwAccount
   Database: SlatwallCommerce
   Slatwall base entity: Account
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccount] (
    [accountID] CHAR(32) NOT NULL,
    [superUserFlag] BIT NULL,
    [firstName] VARCHAR(255) NULL,
    [lastName] VARCHAR(255) NULL,
    [company] VARCHAR(255) NULL,
    [loginLockExpiresDateTime] DATETIME NULL,
    [failedLoginAttemptCount] INT NULL,
    [taxExemptFlag] BIT NULL,
    [cmsAccountID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [remoteEmployeeID] VARCHAR(255) NULL,
    [remoteCustomerID] VARCHAR(255) NULL,
    [remoteContactID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [primaryBillingAddressID] CHAR(32) NULL,
    [primaryEmailAddressID] CHAR(32) NULL,
    [primaryPhoneNumberID] CHAR(32) NULL,
    [primaryAddressID] CHAR(32) NULL,
    [primaryPaymentMethodID] CHAR(32) NULL,
    [primaryShippingAddressID] CHAR(32) NULL,
    [accountCreatedSiteID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccount] PRIMARY KEY CLUSTERED ([accountID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwAccount_remoteCustomerID] ON [dbo].[SwAccount] ([remoteCustomerID])
GO

-- NOTE: [accountCreatedSiteID] references the former SwSite table (dropped 2017); column retained.