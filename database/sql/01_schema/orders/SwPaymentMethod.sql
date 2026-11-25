/* =============================================================================
   Table: dbo.SwPaymentMethod
   Database: SlatwallCommerce
   Slatwall base entity: PaymentMethod
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPaymentMethod] (
    [paymentMethodID] CHAR(32) NOT NULL,
    [paymentMethodName] VARCHAR(255) NULL,
    [paymentMethodType] VARCHAR(255) NULL,
    [allowSaveFlag] BIT NULL,
    [activeFlag] BIT NULL,
    [sortOrder] INT NULL,
    [saveAccountPaymentMethodTransactionType] VARCHAR(255) NULL,
    [saveAccountPaymentMethodEncryptFlag] BIT NULL,
    [saveOrderPaymentTransactionType] VARCHAR(255) NULL,
    [saveOrderPaymentEncryptFlag] BIT NULL,
    [placeOrderChargeTransactionType] VARCHAR(255) NULL,
    [placeOrderCreditTransactionType] VARCHAR(255) NULL,
    [subscriptionRenewalTransactionType] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [paymentIntegrationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPaymentMethod] PRIMARY KEY CLUSTERED ([paymentMethodID])
)
GO
