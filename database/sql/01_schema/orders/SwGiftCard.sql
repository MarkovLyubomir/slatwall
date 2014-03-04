/* =============================================================================
   Table: dbo.SwGiftCard
   Database: SlatwallCommerce
   Slatwall base entity: GiftCard
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwGiftCard] (
    [giftCardID] CHAR(32) NOT NULL,
    [giftCardCode] VARCHAR(255) NULL,
    [giftCardPin] VARCHAR(255) NULL,
    [expirationDate] DATETIME NULL,
    [ownerFirstName] VARCHAR(255) NULL,
    [ownerLastName] VARCHAR(255) NULL,
    [ownerEmailAddress] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [issuedDate] DATETIME NULL,
    [currencyCode] VARCHAR(3) NULL,
    [calculatedBalanceAmount] DECIMAL(19,2) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [originalOrderItemID] CHAR(32) NULL,
    [giftCardExpirationTermID] CHAR(32) NULL,
    [ownerAccountID] CHAR(32) NULL,
    [orderItemGiftRecipientID] CHAR(32) NULL,
    CONSTRAINT [PK_SwGiftCard] PRIMARY KEY CLUSTERED ([giftCardID])
)
GO

-- NOTE: [orderItemGiftRecipientID] references the former SwOrderItemGiftRecipient table (dropped 2017); column retained.