/* =============================================================================
   Table: dbo.SwPermission
   Database: SlatwallCommerce
   Slatwall base entity: Permission
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPermission] (
    [permissionID] CHAR(32) NOT NULL,
    [accessType] VARCHAR(255) NULL,
    [subsystem] VARCHAR(255) NULL,
    [section] VARCHAR(255) NULL,
    [item] VARCHAR(255) NULL,
    [allowActionFlag] BIT NULL,
    [allowCreateFlag] BIT NULL,
    [allowReadFlag] BIT NULL,
    [allowUpdateFlag] BIT NULL,
    [allowDeleteFlag] BIT NULL,
    [allowProcessFlag] BIT NULL,
    [entityClassName] VARCHAR(255) NULL,
    [propertyName] VARCHAR(255) NULL,
    [processContext] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [permissionGroupID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPermission] PRIMARY KEY CLUSTERED ([permissionID])
)
GO
