/* =============================================================================
   Table: dbo.SwAddressZone
   Database: SlatwallCommerce
   Slatwall base entity: AddressZone
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAddressZone] (
    [addressZoneID] CHAR(32) NOT NULL,
    [addressZoneName] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwAddressZone] PRIMARY KEY CLUSTERED ([addressZoneID])
)
GO
