/* =============================================================================
   Table: dbo.SwShippingMethodRate
   Database: SlatwallCommerce
   Slatwall base entity: ShippingMethodRate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwShippingMethodRate] (
    [shippingMethodRateID] CHAR(32) NOT NULL,
    [sortOrder] INT NULL,
    [minimumShipmentWeight] FLOAT NULL,
    [maximumShipmentWeight] FLOAT NULL,
    [minimumShipmentItemPrice] DECIMAL(19,2) NULL,
    [maximumShipmentItemPrice] DECIMAL(19,2) NULL,
    [defaultAmount] DECIMAL(19,2) NULL,
    [shippingIntegrationMethod] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [shippingIntegrationID] CHAR(32) NULL,
    [shippingMethodID] CHAR(32) NULL,
    [addressZoneID] CHAR(32) NULL,
    CONSTRAINT [PK_SwShippingMethodRate] PRIMARY KEY CLUSTERED ([shippingMethodRateID])
)
GO
