/* =============================================================================
   Table: dbo.SwAccountPhoneNumber
   Database: SlatwallCommerce
   Slatwall base entity: AccountPhoneNumber
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountPhoneNumber] (
    [accountPhoneNumberID] CHAR(32) NOT NULL,
    [phoneNumber] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [accountPhoneTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountPhoneNumber] PRIMARY KEY CLUSTERED ([accountPhoneNumberID])
)
GO
