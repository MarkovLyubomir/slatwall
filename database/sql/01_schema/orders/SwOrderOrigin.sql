/* =============================================================================
   Table: dbo.SwOrderOrigin
   Database: SlatwallCommerce
   Slatwall base entity: OrderOrigin
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderOrigin] (
    [orderOriginID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [orderOriginName] VARCHAR(255) NULL,
    [orderOriginType] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwOrderOrigin] PRIMARY KEY CLUSTERED ([orderOriginID])
)
GO
