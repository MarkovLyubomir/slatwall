/* =============================================================================
   Table: dbo.SwPhysicalCountItem
   Database: SlatwallCommerce
   Slatwall base entity: PhysicalCountItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPhysicalCountItem] (
    [physicalCountItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [skuCode] VARCHAR(255) NULL,
    [countPostDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [physicalCountID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPhysicalCountItem] PRIMARY KEY CLUSTERED ([physicalCountItemID])
)
GO
