/* =============================================================================
   Table: dbo.SwLocationAddress
   Database: SlatwallCommerce
   Slatwall base entity: LocationAddress
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLocationAddress] (
    [locationAddressID] CHAR(32) NOT NULL,
    [locationAddressName] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationID] CHAR(32) NULL,
    [addressID] CHAR(32) NULL,
    CONSTRAINT [PK_SwLocationAddress] PRIMARY KEY CLUSTERED ([locationAddressID])
)
GO
