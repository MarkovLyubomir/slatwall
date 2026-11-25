/* =============================================================================
   Table: dbo.SwOrderDeliveryItem
   Database: SlatwallCommerce
   Slatwall base entity: OrderDeliveryItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderDeliveryItem] (
    [orderDeliveryItemID] CHAR(32) NOT NULL,
    [quantity] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderDeliveryID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderDeliveryItem] PRIMARY KEY CLUSTERED ([orderDeliveryItemID])
)
GO
