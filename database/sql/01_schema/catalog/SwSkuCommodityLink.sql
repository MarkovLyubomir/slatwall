/* =============================================================================
   Table: dbo.SwSkuCommodityLink
   Database: SlatwallCommerce
   Links a commodity SKU to its index
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwSkuCommodityLink] (
    [SkuCommodityLinkID] INT IDENTITY(1,1) NOT NULL,
    [skuID] CHAR(32) NOT NULL,
    [IndexCode] VARCHAR(20) NOT NULL,
    [BoardFeetPerUnit] DECIMAL(10,4) NULL,
    [PassThroughPct] DECIMAL(5,2) NULL CONSTRAINT [DF_SwSkuCommodityLink_PassThroughPct] DEFAULT (100),
    [EffectiveDate] DATE NULL,
    CONSTRAINT [PK_SwSkuCommodityLink] PRIMARY KEY CLUSTERED ([SkuCommodityLinkID])
)
GO
