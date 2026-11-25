/* =============================================================================
   Table: dbo.SwAttributeValue
   Database: SlatwallCommerce
   Slatwall base entity: AttributeValue
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAttributeValue] (
    [attributeValueID] CHAR(32) NOT NULL,
    [attributeValue] VARCHAR(4000) NULL,
    [attributeValueEncrypted] VARCHAR(255) NULL,
    [attributeValueEncryptedDateTime] DATETIME NULL,
    [attributeValueEncryptedGenerator] VARCHAR(255) NULL,
    [attributeValueType] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [attributeID] CHAR(32) NULL,
    [attributeValueOptionID] CHAR(32) NULL,
    [accountID] CHAR(32) NULL,
    [accountAddressID] CHAR(32) NULL,
    [accountPaymentID] CHAR(32) NULL,
    [attributeOptionID] CHAR(32) NULL,
    [brandID] CHAR(32) NULL,
    [fileID] CHAR(32) NULL,
    [imageID] CHAR(32) NULL,
    [locationID] CHAR(32) NULL,
    [locationConfigurationID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    [orderPaymentID] CHAR(32) NULL,
    [orderFulfillmentID] CHAR(32) NULL,
    [orderDeliveryID] CHAR(32) NULL,
    [optionGroupID] CHAR(32) NULL,
    [contentID] CHAR(32) NULL,
    [productID] CHAR(32) NULL,
    [productBundleGroupID] CHAR(32) NULL,
    [productTypeID] CHAR(32) NULL,
    [productReviewID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    [siteID] CHAR(32) NULL,
    [subscriptionBenefitID] CHAR(32) NULL,
    [typeID] CHAR(32) NULL,
    [vendorID] CHAR(32) NULL,
    [vendorOrderID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAttributeValue] PRIMARY KEY CLUSTERED ([attributeValueID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwAttributeValue_attributeID] ON [dbo].[SwAttributeValue] ([attributeID])
GO

-- NOTE: [fileID] references the former SwFile table (dropped 2017); column retained.
-- NOTE: [contentID] references the former SwContent table (dropped 2017); column retained.
-- NOTE: [siteID] references the former SwSite table (dropped 2017); column retained.
-- NOTE: [subscriptionBenefitID] references the former SwSubscriptionBenefit table (dropped 2017); column retained.