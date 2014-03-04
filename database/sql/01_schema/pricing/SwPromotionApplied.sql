/* =============================================================================
   Table: dbo.SwPromotionApplied
   Database: SlatwallCommerce
   Slatwall base entity: PromotionApplied
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromotionApplied] (
    [promotionAppliedID] CHAR(32) NOT NULL,
    [discountAmount] DECIMAL(19,2) NULL,
    [appliedType] VARCHAR(255) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [promotionID] CHAR(32) NULL,
    [orderItemID] CHAR(32) NULL,
    [orderfulfillmentID] CHAR(32) NULL,
    [orderID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPromotionApplied] PRIMARY KEY CLUSTERED ([promotionAppliedID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwPromotionApplied_orderItemID] ON [dbo].[SwPromotionApplied] ([orderItemID])
GO
