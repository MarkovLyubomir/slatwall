/* =============================================================================
   Table: dbo.SwAccountPayment
   Database: SlatwallCommerce
   Slatwall base entity: AccountPayment
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountPayment] (
    [accountPaymentID] CHAR(32) NOT NULL,
    [currencyCode] VARCHAR(3) NULL,
    [bankRoutingNumberEncrypted] VARCHAR(255) NULL,
    [bankAccountNumberEncrypted] VARCHAR(255) NULL,
    [checkNumberEncrypted] VARCHAR(255) NULL,
    [companyPaymentMethodFlag] BIT NULL,
    [creditCardNumberEncrypted] VARCHAR(255) NULL,
    [creditCardLastFour] VARCHAR(255) NULL,
    [creditCardType] VARCHAR(255) NULL,
    [expirationMonth] VARCHAR(255) NULL,
    [expirationYear] VARCHAR(255) NULL,
    [giftCardNumberEncrypted] VARCHAR(255) NULL,
    [nameOnCreditCard] VARCHAR(255) NULL,
    [providerToken] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [accountPaymentMethodID] CHAR(32) NULL,
    [accountPaymentTypeID] CHAR(32) NULL,
    [billingAddressID] CHAR(32) NULL,
    [paymentMethodID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountPayment] PRIMARY KEY CLUSTERED ([accountPaymentID])
)
GO
