/* =============================================================================
   Table: dbo.SwOrder
   Database: SlatwallCommerce
   Slatwall base entity: Order
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrder] (
    [orderID] CHAR(32) NOT NULL,
    [orderNumber] VARCHAR(255) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [orderOpenDateTime] DATETIME NULL,
    [orderOpenIPAddress] VARCHAR(255) NULL,
    [orderCloseDateTime] DATETIME NULL,
    [referencedOrderType] VARCHAR(255) NULL,
    [estimatedDeliveryDateTime] DATETIME NULL,
    [estimatedFulfillmentDateTime] DATETIME NULL,
    [calculatedTotal] DECIMAL(19,2) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [assignedAccountID] CHAR(32) NULL,
    [billingAccountAddressID] CHAR(32) NULL,
    [billingAddressID] CHAR(32) NULL,
    [locationID] CHAR(32) NULL,
    [orderTypeID] CHAR(32) NULL,
    [orderStatusTypeID] CHAR(32) NULL,
    [orderOriginID] CHAR(32) NULL,
    [referencedOrderID] CHAR(32) NULL,
    [shippingAccountAddressID] CHAR(32) NULL,
    [shippingAddressID] CHAR(32) NULL,
    [orderCreatedSiteID] CHAR(32) NULL,
    [orderPlacedSiteID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrder] PRIMARY KEY CLUSTERED ([orderID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwOrder_accountID] ON [dbo].[SwOrder] ([accountID])
GO

CREATE NONCLUSTERED INDEX [IX_SwOrder_orderNumber] ON [dbo].[SwOrder] ([orderNumber])
GO

CREATE NONCLUSTERED INDEX [IX_SwOrder_orderStatusTypeID] ON [dbo].[SwOrder] ([orderStatusTypeID])
GO

-- NOTE: [orderCreatedSiteID] references the former SwSite table (dropped 2017); column retained.
-- NOTE: [orderPlacedSiteID] references the former SwSite table (dropped 2017); column retained.