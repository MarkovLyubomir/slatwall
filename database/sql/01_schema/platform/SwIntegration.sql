/* =============================================================================
   Table: dbo.SwIntegration
   Database: SlatwallCommerce
   Slatwall base entity: Integration
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwIntegration] (
    [integrationID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [installedFlag] BIT NULL,
    [integrationPackage] VARCHAR(255) NULL,
    [integrationName] VARCHAR(255) NULL,
    [integrationTypeList] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwIntegration] PRIMARY KEY CLUSTERED ([integrationID])
)
GO
