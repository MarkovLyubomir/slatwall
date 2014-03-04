/* =============================================================================
   Table: dbo.SwAddress
   Database: SlatwallCommerce
   Slatwall base entity: Address
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAddress] (
    [addressID] CHAR(32) NOT NULL,
    [name] VARCHAR(255) NULL,
    [company] VARCHAR(255) NULL,
    [streetAddress] VARCHAR(255) NULL,
    [street2Address] VARCHAR(255) NULL,
    [locality] VARCHAR(255) NULL,
    [city] VARCHAR(255) NULL,
    [stateCode] VARCHAR(255) NULL,
    [postalCode] VARCHAR(255) NULL,
    [countryCode] VARCHAR(255) NULL,
    [salutation] VARCHAR(255) NULL,
    [firstName] VARCHAR(255) NULL,
    [lastName] VARCHAR(255) NULL,
    [middleName] VARCHAR(255) NULL,
    [middleInitial] VARCHAR(255) NULL,
    [phoneNumber] VARCHAR(255) NULL,
    [emailAddress] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwAddress] PRIMARY KEY CLUSTERED ([addressID])
)
GO
