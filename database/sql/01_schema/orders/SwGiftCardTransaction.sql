/* =============================================================================
   Table: dbo.SwGiftCardTransaction
   Database: SlatwallCommerce
   Slatwall base entity: GiftCardTransaction
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwGiftCardTransaction] (
    [giftCardTransactionID] CHAR(32) NOT NULL,
    [creditAmount] DECIMAL(19,2) NULL,
    [debitAmount] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderPaymentID] CHAR(32) NULL,
    [giftCardID] CHAR(32) NULL,
    CONSTRAINT [PK_SwGiftCardTransaction] PRIMARY KEY CLUSTERED ([giftCardTransactionID])
)
GO
