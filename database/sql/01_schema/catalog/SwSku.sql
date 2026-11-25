/* =============================================================================
   Table: dbo.SwSku
   Database: SlatwallCommerce
   Slatwall base entity: Sku
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSku] (
    [skuID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [publishedFlag] BIT NULL,
    [skuName] VARCHAR(255) NULL,
    [skuDescription] VARCHAR(4000) NULL,
    [skuCode] VARCHAR(50) NULL,
    [eventAttendanceCode] VARCHAR(8) NULL,
    [listPrice] DECIMAL(19,2) NULL,
    [price] DECIMAL(19,2) NULL,
    [renewalPrice] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [imageFile] VARCHAR(250) NULL,
    [userDefinedPriceFlag] BIT NULL,
    [eventStartDateTime] DATETIME NULL,
    [eventEndDateTime] DATETIME NULL,
    [startReservationDateTime] DATETIME NULL,
    [endReservationDateTime] DATETIME NULL,
    [purchaseStartDateTime] DATETIME NULL,
    [purchaseEndDateTime] DATETIME NULL,
    [bundleFlag] BIT NULL,
    [eventCapacity] INT NULL,
    [attendedQuantity] INT NULL,
    [allowEventWaitlistingFlag] BIT NULL,
    [redemptionAmountType] VARCHAR(255) NULL,
    [redemptionAmount] DECIMAL(19,2) NULL,
    [calculatedQATS] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [productID] CHAR(32) NULL,
    [productScheduleID] CHAR(32) NULL,
    [renewalSkuID] CHAR(32) NULL,
    [subscriptionTermID] CHAR(32) NULL,
    [termID] CHAR(32) NULL,
    [giftCardExpirationTermID] CHAR(32) NULL,
    CONSTRAINT [PK_SwSku] PRIMARY KEY CLUSTERED ([skuID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwSku_skuCode] ON [dbo].[SwSku] ([skuCode])
GO

CREATE NONCLUSTERED INDEX [IX_SwSku_productID] ON [dbo].[SwSku] ([productID])
GO

-- NOTE: [productScheduleID] references the former SwProductSchedule table (dropped 2017); column retained.
-- NOTE: [subscriptionTermID] references the former SwSubscriptionTerm table (dropped 2017); column retained.