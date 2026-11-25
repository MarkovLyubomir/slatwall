/* =============================================================================
   Table: dbo.SwAccountEmailAddress
   Database: SlatwallCommerce
   Slatwall base entity: AccountEmailAddress
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountEmailAddress] (
    [accountEmailAddressID] CHAR(32) NOT NULL,
    [emailAddress] VARCHAR(255) NULL,
    [verifiedFlag] BIT NULL,
    [verificationCode] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [accountEmailTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountEmailAddress] PRIMARY KEY CLUSTERED ([accountEmailAddressID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwAccountEmailAddress_email] ON [dbo].[SwAccountEmailAddress] ([emailAddress])
GO
