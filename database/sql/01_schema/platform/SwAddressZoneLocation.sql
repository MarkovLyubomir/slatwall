/* =============================================================================
   Table: dbo.SwAddressZoneLocation
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAddressZoneLocation] (
    [addressZoneID] CHAR(32) NOT NULL,
    [addressID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwAddressZoneLocation] PRIMARY KEY CLUSTERED ([addressZoneID], [addressID])
)
GO
