/* =============================================================================
   Table: dbo.SwSession
   Database: SlatwallCommerce
   Slatwall base entity: Session
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSession] (
    [sessionID] CHAR(32) NOT NULL,
    [shippingAddressPostalCode] VARCHAR(255) NULL,
    [lastRequestDateTime] DATETIME NULL,
    [lastRequestIPAddress] VARCHAR(255) NULL,
    [lastPlacedOrderID] VARCHAR(255) NULL,
    [rbLocale] VARCHAR(255) NULL,
    [sessionCookiePSID] VARCHAR(64) NULL,
    [sessionCookieNPSID] VARCHAR(64) NULL,
    [sessionExpirationDateTime] DATETIME NULL,
    [deviceID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [modifiedDateTime] DATETIME NULL,
    [accountID] CHAR(32) NULL,
    [accountAuthenticationID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    CONSTRAINT [PK_SwSession] PRIMARY KEY CLUSTERED ([sessionID])
)
GO
