/* =============================================================================
   Table: dbo.SwPromoRewardFulfillmentMethod
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPromoRewardFulfillmentMethod] (
    [promotionRewardID] CHAR(32) NOT NULL,
    [fulfillmentMethodID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwPromoRewardFulfillmentMethod] PRIMARY KEY CLUSTERED ([promotionRewardID], [fulfillmentMethodID])
)
GO
