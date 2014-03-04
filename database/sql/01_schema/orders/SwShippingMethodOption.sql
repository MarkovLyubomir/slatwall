/* =============================================================================
   Table: dbo.SwShippingMethodOption
   Database: SlatwallCommerce
   Slatwall base entity: ShippingMethodOption
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwShippingMethodOption] (
    [shippingMethodOptionID] CHAR(32) NOT NULL,
    [totalCharge] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [totalShippingWeight] VARCHAR(255) NULL,
    [totalShippingItemPrice] VARCHAR(255) NULL,
    [shipToPostalCode] VARCHAR(255) NULL,
    [shipToStateCode] VARCHAR(255) NULL,
    [shipToCountryCode] VARCHAR(255) NULL,
    [shipToCity] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [shippingMethodRateID] CHAR(32) NULL,
    [orderFulfillmentID] CHAR(32) NULL,
    CONSTRAINT [PK_SwShippingMethodOption] PRIMARY KEY CLUSTERED ([shippingMethodOptionID])
)
GO
