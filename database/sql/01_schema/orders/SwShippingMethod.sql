/* =============================================================================
   Table: dbo.SwShippingMethod
   Database: SlatwallCommerce
   Slatwall base entity: ShippingMethod
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwShippingMethod] (
    [shippingMethodID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [shippingMethodName] VARCHAR(255) NULL,
    [shippingMethodCode] VARCHAR(255) NULL,
    [sortOrder] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [fulfillmentMethodID] CHAR(32) NULL,
    [addressZoneID] CHAR(32) NULL,
    CONSTRAINT [PK_SwShippingMethod] PRIMARY KEY CLUSTERED ([shippingMethodID])
)
GO
