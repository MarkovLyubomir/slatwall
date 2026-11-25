/* =============================================================================
   Table: dbo.SwOrderItem
   Database: SlatwallCommerce
   Slatwall base entity: OrderItem
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderItem] (
    [orderItemID] CHAR(32) NOT NULL,
    [price] DECIMAL(19,2) NULL,
    [skuPrice] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [quantity] INT NULL,
    [estimatedDeliveryDateTime] DATETIME NULL,
    [estimatedFulfillmentDateTime] DATETIME NULL,
    [publicRemoteID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [appliedPriceGroupID] CHAR(32) NULL,
    [orderItemTypeID] CHAR(32) NULL,
    [orderItemStatusTypeID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    [stockID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    [orderFulfillmentID] CHAR(32) NULL,
    [orderReturnID] CHAR(32) NULL,
    [parentOrderItemID] CHAR(32) NULL,
    [productBundleGroupID] CHAR(32) NULL,
    [referencedOrderItemID] CHAR(32) NULL,
    [giftCardTransactionID] CHAR(32) NULL,
    [referencedOrderDeliveryItemID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderItem] PRIMARY KEY CLUSTERED ([orderItemID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwOrderItem_orderID] ON [dbo].[SwOrderItem] ([orderID])
GO

CREATE NONCLUSTERED INDEX [IX_SwOrderItem_skuID] ON [dbo].[SwOrderItem] ([skuID])
GO
