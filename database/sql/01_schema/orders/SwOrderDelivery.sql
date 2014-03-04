/* =============================================================================
   Table: dbo.SwOrderDelivery
   Database: SlatwallCommerce
   Slatwall base entity: OrderDelivery
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderDelivery] (
    [orderDeliveryID] CHAR(32) NOT NULL,
    [trackingNumber] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderID] CHAR(32) NULL,
    [locationID] CHAR(32) NULL,
    [fulfillmentMethodID] CHAR(32) NULL,
    [shippingMethodID] CHAR(32) NULL,
    [shippingAddressID] CHAR(32) NULL,
    [paymentTransactionID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderDelivery] PRIMARY KEY CLUSTERED ([orderDeliveryID])
)
GO
