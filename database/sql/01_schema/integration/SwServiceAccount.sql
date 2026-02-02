/* =============================================================================
   Table: dbo.SwServiceAccount
   Database: SlatwallCommerce
   Integration service accounts (TR-08 register, incomplete)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwServiceAccount] (
    [ServiceAccountID] INT IDENTITY(1,1) NOT NULL,
    [LoginName] VARCHAR(60) NOT NULL,
    [Purpose] VARCHAR(100) NULL,
    [Owner] VARCHAR(60) NULL,
    [CreatedOn] DATETIME NULL CONSTRAINT [DF_SwServiceAccount_CreatedOn] DEFAULT (GETDATE()),
    [LastReviewedOn] DATE NULL,
    [ExpiresOn] DATE NULL,
    [PasswordInConfigFlag] BIT NULL CONSTRAINT [DF_SwServiceAccount_PasswordInConfigFlag] DEFAULT (1),
    CONSTRAINT [PK_SwServiceAccount] PRIMARY KEY CLUSTERED ([ServiceAccountID])
)
GO
