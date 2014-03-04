/* =============================================================================
   Table: dbo.SwPhysicalCount
   Database: SlatwallCommerce
   Slatwall base entity: PhysicalCount
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPhysicalCount] (
    [physicalCountID] CHAR(32) NOT NULL,
    [countPostDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [locationID] CHAR(32) NULL,
    [physicalID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPhysicalCount] PRIMARY KEY CLUSTERED ([physicalCountID])
)
GO
