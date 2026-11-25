/* =============================================================================
   Table: dbo.SwPhysical
   Database: SlatwallCommerce
   Slatwall base entity: Physical
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPhysical] (
    [physicalID] CHAR(32) NOT NULL,
    [physicalName] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [physicalStatusTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPhysical] PRIMARY KEY CLUSTERED ([physicalID])
)
GO
