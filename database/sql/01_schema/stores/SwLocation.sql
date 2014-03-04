/* =============================================================================
   Table: dbo.SwLocation
   Database: SlatwallCommerce
   Slatwall base entity: Location
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLocation] (
    [locationID] CHAR(32) NOT NULL,
    [locationIDPath] VARCHAR(255) NULL,
    [locationName] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationAddressID] CHAR(32) NULL,
    [parentLocationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwLocation] PRIMARY KEY CLUSTERED ([locationID])
)
GO
