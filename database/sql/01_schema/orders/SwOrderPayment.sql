/* =============================================================================
   Table: dbo.SwOrderPayment
   Database: SlatwallCommerce
   Slatwall base entity: OrderPayment
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderPayment] (
    [orderPaymentID] CHAR(32) NOT NULL,
    [amount] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [bankRoutingNumberEncrypted] VARCHAR(255) NULL,
    [bankAccountNumberEncrypted] VARCHAR(255) NULL,
    [checkNumberEncrypted] VARCHAR(255) NULL,
    [companyPaymentMethodFlag] BIT NULL,
    [creditCardNumberEncrypted] VARCHAR(255) NULL,
    [creditCardNumberEncryptedDateTime] DATETIME NULL,
    [creditCardNumberEncryptedGenerator] VARCHAR(255) NULL,
    [creditCardLastFour] VARCHAR(255) NULL,
    [creditCardType] VARCHAR(255) NULL,
    [expirationMonth] VARCHAR(255) NULL,
    [expirationYear] VARCHAR(255) NULL,
    [giftCardNumberEncrypted] VARCHAR(255) NULL,
    [nameOnCreditCard] VARCHAR(255) NULL,
    [paymentDueDate] DATETIME NULL,
    [providerToken] VARCHAR(255) NULL,
    [purchaseOrderNumber] VARCHAR(255) NULL,
    [giftCardPaymentProcessedFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountPaymentMethodID] CHAR(32) NULL,
    [billingAccountAddressID] CHAR(32) NULL,
    [billingAddressID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    [orderPaymentTypeID] CHAR(32) NULL,
    [orderPaymentStatusTypeID] CHAR(32) NULL,
    [paymentMethodID] CHAR(32) NULL,
    [paymentTermID] CHAR(32) NULL,
    [referencedOrderPaymentID] CHAR(32) NULL,
    [termPaymentAccountID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderPayment] PRIMARY KEY CLUSTERED ([orderPaymentID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwOrderPayment_orderID] ON [dbo].[SwOrderPayment] ([orderID])
GO
