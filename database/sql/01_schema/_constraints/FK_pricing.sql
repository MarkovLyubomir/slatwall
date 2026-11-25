/* Foreign keys - pricing domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwPriceGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroup_parentPriceGroupID] FOREIGN KEY ([parentPriceGroupID]) REFERENCES [dbo].[SwPriceGroup] ([priceGroupID])
GO
ALTER TABLE [dbo].[SwPriceGroupRate] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRate_priceGroupID] FOREIGN KEY ([priceGroupID]) REFERENCES [dbo].[SwPriceGroup] ([priceGroupID])
GO
ALTER TABLE [dbo].[SwPriceGroupRate] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRate_roundingRuleID] FOREIGN KEY ([roundingRuleID]) REFERENCES [dbo].[SwRoundingRule] ([roundingRuleID])
GO
ALTER TABLE [dbo].[SwPromotion] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotion_defaultImageID] FOREIGN KEY ([defaultImageID]) REFERENCES [dbo].[SwImage] ([imageID])
GO
ALTER TABLE [dbo].[SwPromotionAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionAccount_promotionID] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[SwPromotion] ([promotionID])
GO
ALTER TABLE [dbo].[SwPromotionAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionAccount_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwPromotionApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionApplied_promotionID] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[SwPromotion] ([promotionID])
GO
ALTER TABLE [dbo].[SwPromotionApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionApplied_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwPromotionApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionApplied_orderfulfillmentID] FOREIGN KEY ([orderfulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwPromotionApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionApplied_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwPromotionCode] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionCode_promotionID] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[SwPromotion] ([promotionID])
GO
ALTER TABLE [dbo].[SwPromotionPeriod] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionPeriod_promotionID] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[SwPromotion] ([promotionID])
GO
ALTER TABLE [dbo].[SwPromoQual] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQual_promotionPeriodID] FOREIGN KEY ([promotionPeriodID]) REFERENCES [dbo].[SwPromotionPeriod] ([promotionPeriodID])
GO
ALTER TABLE [dbo].[SwPromoReward] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoReward_promotionPeriodID] FOREIGN KEY ([promotionPeriodID]) REFERENCES [dbo].[SwPromotionPeriod] ([promotionPeriodID])
GO
ALTER TABLE [dbo].[SwPromoReward] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoReward_roundingRuleID] FOREIGN KEY ([roundingRuleID]) REFERENCES [dbo].[SwRoundingRule] ([roundingRuleID])
GO
ALTER TABLE [dbo].[SwPromotionRewardCurrency] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionRewardCurrency_currencyCode] FOREIGN KEY ([currencyCode]) REFERENCES [dbo].[SwCurrency] ([currencyCode])
GO
ALTER TABLE [dbo].[SwPromotionRewardCurrency] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionRewardCurrency_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwTaxApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwTaxApplied_taxCategoryRateID] FOREIGN KEY ([taxCategoryRateID]) REFERENCES [dbo].[SwTaxCategoryRate] ([taxCategoryRateID])
GO
ALTER TABLE [dbo].[SwTaxApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwTaxApplied_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwTaxCategoryRate] WITH NOCHECK ADD CONSTRAINT [FK_SwTaxCategoryRate_addressZoneID] FOREIGN KEY ([addressZoneID]) REFERENCES [dbo].[SwAddressZone] ([addressZoneID])
GO
ALTER TABLE [dbo].[SwTaxCategoryRate] WITH NOCHECK ADD CONSTRAINT [FK_SwTaxCategoryRate_taxCategoryID] FOREIGN KEY ([taxCategoryID]) REFERENCES [dbo].[SwTaxCategory] ([taxCategoryID])
GO
ALTER TABLE [dbo].[SwTaxCategoryRate] WITH NOCHECK ADD CONSTRAINT [FK_SwTaxCategoryRate_taxIntegrationID] FOREIGN KEY ([taxIntegrationID]) REFERENCES [dbo].[SwIntegration] ([integrationID])
GO
ALTER TABLE [dbo].[SwPromotionCodeAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionCodeAccount_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwPromotionCodeAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwPromotionCodeAccount_promotionCodeID] FOREIGN KEY ([promotionCodeID]) REFERENCES [dbo].[SwPromotionCode] ([promotionCodeID])
GO
ALTER TABLE [dbo].[SwPromoRewardBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardBrand_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwPromoRewardBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardBrand_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoQualBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualBrand_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwPromoQualBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualBrand_promotionQualifierID] FOREIGN KEY ([promotionQualifierID]) REFERENCES [dbo].[SwPromoQual] ([promotionQualifierID])
GO
ALTER TABLE [dbo].[SwPromoRewardEligiblePriceGrp] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardEligiblePriceGrp_priceGroupID] FOREIGN KEY ([priceGroupID]) REFERENCES [dbo].[SwPriceGroup] ([priceGroupID])
GO
ALTER TABLE [dbo].[SwPromoRewardEligiblePriceGrp] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardEligiblePriceGrp_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateProductType_priceGroupRateID] FOREIGN KEY ([priceGroupRateID]) REFERENCES [dbo].[SwPriceGroupRate] ([priceGroupRateID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateProductType_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateProduct_priceGroupRateID] FOREIGN KEY ([priceGroupRateID]) REFERENCES [dbo].[SwPriceGroupRate] ([priceGroupRateID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateSku_priceGroupRateID] FOREIGN KEY ([priceGroupRateID]) REFERENCES [dbo].[SwPriceGroupRate] ([priceGroupRateID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateSku_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateExclProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateExclProduct_priceGroupRateID] FOREIGN KEY ([priceGroupRateID]) REFERENCES [dbo].[SwPriceGroupRate] ([priceGroupRateID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateExclProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateExclProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateExclSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateExclSku_priceGroupRateID] FOREIGN KEY ([priceGroupRateID]) REFERENCES [dbo].[SwPriceGroupRate] ([priceGroupRateID])
GO
ALTER TABLE [dbo].[SwPriceGroupRateExclSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPriceGroupRateExclSku_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwPromoRewardProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPromoRewardProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardProduct_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoQualProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPromoQualProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualProduct_promotionQualifierID] FOREIGN KEY ([promotionQualifierID]) REFERENCES [dbo].[SwPromoQual] ([promotionQualifierID])
GO
ALTER TABLE [dbo].[SwPromoQualExclProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualExclProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPromoQualExclProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualExclProduct_promotionQualifierID] FOREIGN KEY ([promotionQualifierID]) REFERENCES [dbo].[SwPromoQual] ([promotionQualifierID])
GO
ALTER TABLE [dbo].[SwPromoRewardProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardProductType_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwPromoRewardProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardProductType_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoQualProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualProductType_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwPromoQualProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualProductType_promotionQualifierID] FOREIGN KEY ([promotionQualifierID]) REFERENCES [dbo].[SwPromoQual] ([promotionQualifierID])
GO
ALTER TABLE [dbo].[SwPromoQualSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualSku_promotionQualifierID] FOREIGN KEY ([promotionQualifierID]) REFERENCES [dbo].[SwPromoQual] ([promotionQualifierID])
GO
ALTER TABLE [dbo].[SwPromoQualSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoQualSku_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwPromoRewardFulfillmentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardFulfillmentMethod_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoRewardFulfillmentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardFulfillmentMethod_fulfillmentMethodID] FOREIGN KEY ([fulfillmentMethodID]) REFERENCES [dbo].[SwFulfillmentMethod] ([fulfillmentMethodID])
GO
ALTER TABLE [dbo].[SwPromoRewardSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardSku_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoRewardSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardSku_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwPromoRewardExclSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardExclSku_promotionRewardID] FOREIGN KEY ([promotionRewardID]) REFERENCES [dbo].[SwPromoReward] ([promotionRewardID])
GO
ALTER TABLE [dbo].[SwPromoRewardExclSku] WITH NOCHECK ADD CONSTRAINT [FK_SwPromoRewardExclSku_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwZonePrice] WITH NOCHECK ADD CONSTRAINT [FK_SwZonePrice_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProTierPrice] WITH NOCHECK ADD CONSTRAINT [FK_SwProTierPrice_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProTierPrice] WITH NOCHECK ADD CONSTRAINT [FK_SwProTierPrice_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwContractPrice] WITH NOCHECK ADD CONSTRAINT [FK_SwContractPrice_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwContractPrice] WITH NOCHECK ADD CONSTRAINT [FK_SwContractPrice_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwQuote] WITH NOCHECK ADD CONSTRAINT [FK_SwQuote_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwQuote] WITH NOCHECK ADD CONSTRAINT [FK_SwQuote_ConvertedOrderID] FOREIGN KEY ([ConvertedOrderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwQuoteLine] WITH NOCHECK ADD CONSTRAINT [FK_SwQuoteLine_QuoteID] FOREIGN KEY ([QuoteID]) REFERENCES [dbo].[SwQuote] ([QuoteID])
GO
ALTER TABLE [dbo].[SwQuoteLine] WITH NOCHECK ADD CONSTRAINT [FK_SwQuoteLine_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
