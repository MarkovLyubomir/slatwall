/* =============================================================================
   Table: dbo.SwAccountAddress
   Database: SlatwallCommerce
   Slatwall base entity: AccountAddress
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountAddress] (
    [accountAddressID] CHAR(32) NOT NULL,
    [accountAddressName] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [addressID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountAddress] PRIMARY KEY CLUSTERED ([accountAddressID])
)
GO
