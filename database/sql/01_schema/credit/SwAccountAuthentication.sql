/* =============================================================================
   Table: dbo.SwAccountAuthentication
   Database: SlatwallCommerce
   Slatwall base entity: AccountAuthentication
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountAuthentication] (
    [accountAuthenticationID] CHAR(32) NOT NULL,
    [password] VARCHAR(255) NULL,
    [accessKey] VARCHAR(255) NULL,
    [accessKeyPassword] VARCHAR(255) NULL,
    [expirationDateTime] DATETIME NULL,
    [integrationAccountID] VARCHAR(255) NULL,
    [integrationAccessToken] VARCHAR(255) NULL,
    [integrationAccessTokenExpiration] VARCHAR(255) NULL,
    [integrationRefreshToken] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [updatePasswordOnNextLoginFlag] BIT NULL,
    [authenticationDescription] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [integrationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountAuthentication] PRIMARY KEY CLUSTERED ([accountAuthenticationID])
)
GO
