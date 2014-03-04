/* =============================================================================
   Table: dbo.SwPaymentTransaction
   Database: SlatwallCommerce
   Slatwall base entity: PaymentTransaction
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPaymentTransaction] (
    [paymentTransactionID] CHAR(32) NOT NULL,
    [transactionType] VARCHAR(255) NULL,
    [transactionStartTickCount] VARCHAR(255) NULL,
    [transactionEndTickCount] VARCHAR(255) NULL,
    [transactionSuccessFlag] BIT NULL,
    [providerTransactionID] VARCHAR(255) NULL,
    [transactionDateTime] DATETIME NULL,
    [authorizationCode] VARCHAR(255) NULL,
    [authorizationCodeUsed] VARCHAR(255) NULL,
    [authorizationCodeInvalidFlag] BIT NULL,
    [amountAuthorized] DECIMAL(19,2) NULL,
    [amountReceived] DECIMAL(19,2) NULL,
    [amountCredited] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [securityCodeMatchFlag] BIT NULL,
    [avsCode] VARCHAR(255) NULL,
    [statusCode] VARCHAR(255) NULL,
    [message] VARCHAR(4000) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [amountCharged] DECIMAL(19,2) NULL,
    [accountPaymentID] CHAR(32) NULL,
    [accountPaymentMethodID] CHAR(32) NULL,
    [orderPaymentID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPaymentTransaction] PRIMARY KEY CLUSTERED ([paymentTransactionID])
)
GO
