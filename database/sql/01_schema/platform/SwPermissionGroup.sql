/* =============================================================================
   Table: dbo.SwPermissionGroup
   Database: SlatwallCommerce
   Slatwall base entity: PermissionGroup
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPermissionGroup] (
    [permissionGroupID] CHAR(32) NOT NULL,
    [permissionGroupName] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwPermissionGroup] PRIMARY KEY CLUSTERED ([permissionGroupID])
)
GO
