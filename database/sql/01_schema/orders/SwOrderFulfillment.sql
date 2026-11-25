/* =============================================================================
   Table: dbo.SwOrderFulfillment
   Database: SlatwallCommerce
   Slatwall base entity: OrderFulfillment
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderFulfillment] (
    [orderFulfillmentID] CHAR(32) NOT NULL,
    [fulfillmentCharge] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [emailAddress] VARCHAR(255) NULL,
    [manualFulfillmentChargeFlag] BIT NULL,
    [estimatedDeliveryDateTime] DATETIME NULL,
    [estimatedFulfillmentDateTime] DATETIME NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountAddressID] CHAR(32) NULL,
    [accountEmailAddressID] CHAR(32) NULL,
    [fulfillmentMethodID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    [locationID] CHAR(32) NULL,
    [shippingAddressID] CHAR(32) NULL,
    [shippingMethodID] CHAR(32) NULL,
    [orderFulfillmentStatusTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderFulfillment] PRIMARY KEY CLUSTERED ([orderFulfillmentID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwOrderFulfillment_orderID] ON [dbo].[SwOrderFulfillment] ([orderID])
GO
