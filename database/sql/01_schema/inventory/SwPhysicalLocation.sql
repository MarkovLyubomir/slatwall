/* =============================================================================
   Table: dbo.SwPhysicalLocation
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPhysicalLocation] (
    [locationID] CHAR(32) NOT NULL,
    [physicalID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPhysicalLocation] PRIMARY KEY CLUSTERED ([locationID], [physicalID])
)
GO
