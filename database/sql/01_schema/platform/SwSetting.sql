/* =============================================================================
   Table: dbo.SwSetting
   Database: SlatwallCommerce
   Slatwall base entity: Setting
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSetting] (
    [settingID] CHAR(32) NOT NULL,
    [settingName] VARCHAR(255) NULL,
    [settingValue] VARCHAR(4000) NULL,
    [settingValueEncryptedDateTime] DATETIME NULL,
    [settingValueEncryptedGenerator] VARCHAR(255) NULL,
    [cmsContentID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [brandID] CHAR(32) NULL,
    [contentID] CHAR(32) NULL,
    [emailID] CHAR(32) NULL,
    [emailTemplateID] CHAR(32) NULL,
    [fulfillmentMethodID] CHAR(32) NULL,
    [locationID] CHAR(32) NULL,
    [locationConfigurationID] CHAR(32) NULL,
    [paymentMethodID] CHAR(32) NULL,
    [productID] CHAR(32) NULL,
    [productTypeID] CHAR(32) NULL,
    [shippingMethodID] CHAR(32) NULL,
    [shippingMethodRateID] CHAR(32) NULL,
    [siteID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    [subscriptionTermID] CHAR(32) NULL,
    [subscriptionUsageID] CHAR(32) NULL,
    [taskID] CHAR(32) NULL,
    CONSTRAINT [PK_SwSetting] PRIMARY KEY CLUSTERED ([settingID])
)
GO

-- NOTE: [contentID] references the former SwContent table (dropped 2017); column retained.
-- NOTE: [siteID] references the former SwSite table (dropped 2017); column retained.
-- NOTE: [subscriptionTermID] references the former SwSubscriptionTerm table (dropped 2017); column retained.
-- NOTE: [subscriptionUsageID] references the former SwSubscriptionUsage table (dropped 2017); column retained.