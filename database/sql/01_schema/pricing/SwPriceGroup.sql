/* =============================================================================
   Table: dbo.SwPriceGroup
   Database: SlatwallCommerce
   Slatwall base entity: PriceGroup
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPriceGroup] (
    [priceGroupID] CHAR(32) NOT NULL,
    [priceGroupIDPath] VARCHAR(4000) NULL,
    [activeFlag] BIT NULL,
    [priceGroupName] VARCHAR(255) NULL,
    [priceGroupCode] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [parentPriceGroupID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPriceGroup] PRIMARY KEY CLUSTERED ([priceGroupID])
)
GO
