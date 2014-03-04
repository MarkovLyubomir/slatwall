/* =============================================================================
   Table: dbo.SwLocationConfiguration
   Database: SlatwallCommerce
   Slatwall base entity: LocationConfiguration
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwLocationConfiguration] (
    [locationConfigurationID] CHAR(32) NOT NULL,
    [locationConfigurationName] VARCHAR(255) NULL,
    [locationConfigurationCapacity] INT NULL,
    [activeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwLocationConfiguration] PRIMARY KEY CLUSTERED ([locationConfigurationID])
)
GO
