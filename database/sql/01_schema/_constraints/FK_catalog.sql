/* Foreign keys - catalog domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwAlternateSkuCode] WITH NOCHECK ADD CONSTRAINT [FK_SwAlternateSkuCode_skuTypeID] FOREIGN KEY ([skuTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAlternateSkuCode] WITH NOCHECK ADD CONSTRAINT [FK_SwAlternateSkuCode_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwAttribute] WITH NOCHECK ADD CONSTRAINT [FK_SwAttribute_typeSetID] FOREIGN KEY ([typeSetID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAttribute] WITH NOCHECK ADD CONSTRAINT [FK_SwAttribute_attributeSetID] FOREIGN KEY ([attributeSetID]) REFERENCES [dbo].[SwAttributeSet] ([attributeSetID])
GO
ALTER TABLE [dbo].[SwAttribute] WITH NOCHECK ADD CONSTRAINT [FK_SwAttribute_validationTypeID] FOREIGN KEY ([validationTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAttributeOption] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeOption_attributeID] FOREIGN KEY ([attributeID]) REFERENCES [dbo].[SwAttribute] ([attributeID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_attributeID] FOREIGN KEY ([attributeID]) REFERENCES [dbo].[SwAttribute] ([attributeID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_attributeValueOptionID] FOREIGN KEY ([attributeValueOptionID]) REFERENCES [dbo].[SwAttributeOption] ([attributeOptionID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_accountAddressID] FOREIGN KEY ([accountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_accountPaymentID] FOREIGN KEY ([accountPaymentID]) REFERENCES [dbo].[SwAccountPayment] ([accountPaymentID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_attributeOptionID] FOREIGN KEY ([attributeOptionID]) REFERENCES [dbo].[SwAttributeOption] ([attributeOptionID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_imageID] FOREIGN KEY ([imageID]) REFERENCES [dbo].[SwImage] ([imageID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_locationConfigurationID] FOREIGN KEY ([locationConfigurationID]) REFERENCES [dbo].[SwLocationConfiguration] ([locationConfigurationID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_orderPaymentID] FOREIGN KEY ([orderPaymentID]) REFERENCES [dbo].[SwOrderPayment] ([orderPaymentID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_orderFulfillmentID] FOREIGN KEY ([orderFulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_orderDeliveryID] FOREIGN KEY ([orderDeliveryID]) REFERENCES [dbo].[SwOrderDelivery] ([orderDeliveryID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_optionGroupID] FOREIGN KEY ([optionGroupID]) REFERENCES [dbo].[SwOptionGroup] ([optionGroupID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_productBundleGroupID] FOREIGN KEY ([productBundleGroupID]) REFERENCES [dbo].[SwProductBundleGroup] ([productBundleGroupID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_productReviewID] FOREIGN KEY ([productReviewID]) REFERENCES [dbo].[SwProductReview] ([productReviewID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_typeID] FOREIGN KEY ([typeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwAttributeValue] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeValue_vendorOrderID] FOREIGN KEY ([vendorOrderID]) REFERENCES [dbo].[SwVendorOrder] ([vendorOrderID])
GO
ALTER TABLE [dbo].[SwCategory] WITH NOCHECK ADD CONSTRAINT [FK_SwCategory_parentCategoryID] FOREIGN KEY ([parentCategoryID]) REFERENCES [dbo].[SwCategory] ([categoryID])
GO
ALTER TABLE [dbo].[SwOption] WITH NOCHECK ADD CONSTRAINT [FK_SwOption_optionGroupID] FOREIGN KEY ([optionGroupID]) REFERENCES [dbo].[SwOptionGroup] ([optionGroupID])
GO
ALTER TABLE [dbo].[SwOption] WITH NOCHECK ADD CONSTRAINT [FK_SwOption_defaultImageID] FOREIGN KEY ([defaultImageID]) REFERENCES [dbo].[SwImage] ([imageID])
GO
ALTER TABLE [dbo].[SwProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwProduct_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwProduct_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwProduct_defaultSkuID] FOREIGN KEY ([defaultSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwProduct_renewalSkuID] FOREIGN KEY ([renewalSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProductBundleBuild] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuild_productBundleSkuID] FOREIGN KEY ([productBundleSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProductBundleBuild] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuild_sessionID] FOREIGN KEY ([sessionID]) REFERENCES [dbo].[SwSession] ([sessionID])
GO
ALTER TABLE [dbo].[SwProductBundleBuild] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuild_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwProductBundleBuildItem] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuildItem_productBundleBuildID] FOREIGN KEY ([productBundleBuildID]) REFERENCES [dbo].[SwProductBundleBuild] ([productBundleBuildID])
GO
ALTER TABLE [dbo].[SwProductBundleBuildItem] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuildItem_productBundleGroupID] FOREIGN KEY ([productBundleGroupID]) REFERENCES [dbo].[SwProductBundleGroup] ([productBundleGroupID])
GO
ALTER TABLE [dbo].[SwProductBundleBuildItem] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleBuildItem_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProductBundleGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleGroup_productBundleSkuID] FOREIGN KEY ([productBundleSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProductBundleGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwProductBundleGroup_productBundleGroupTypeID] FOREIGN KEY ([productBundleGroupTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwProductReview] WITH NOCHECK ADD CONSTRAINT [FK_SwProductReview_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwProductReview] WITH NOCHECK ADD CONSTRAINT [FK_SwProductReview_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwProductReview] WITH NOCHECK ADD CONSTRAINT [FK_SwProductReview_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwProductType_parentProductTypeID] FOREIGN KEY ([parentProductTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwSku] WITH NOCHECK ADD CONSTRAINT [FK_SwSku_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwSku] WITH NOCHECK ADD CONSTRAINT [FK_SwSku_renewalSkuID] FOREIGN KEY ([renewalSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwSku] WITH NOCHECK ADD CONSTRAINT [FK_SwSku_termID] FOREIGN KEY ([termID]) REFERENCES [dbo].[SwTerm] ([termID])
GO
ALTER TABLE [dbo].[SwSku] WITH NOCHECK ADD CONSTRAINT [FK_SwSku_giftCardExpirationTermID] FOREIGN KEY ([giftCardExpirationTermID]) REFERENCES [dbo].[SwTerm] ([termID])
GO
ALTER TABLE [dbo].[SwSkuBundle] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuBundle_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwSkuBundle] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuBundle_bundledSkuID] FOREIGN KEY ([bundledSkuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwSkuCurrency] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuCurrency_currencyCode] FOREIGN KEY ([currencyCode]) REFERENCES [dbo].[SwCurrency] ([currencyCode])
GO
ALTER TABLE [dbo].[SwSkuCurrency] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuCurrency_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwAttributeSetProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeSetProductType_attributeSetID] FOREIGN KEY ([attributeSetID]) REFERENCES [dbo].[SwAttributeSet] ([attributeSetID])
GO
ALTER TABLE [dbo].[SwAttributeSetProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwAttributeSetProductType_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwProductCategory] WITH NOCHECK ADD CONSTRAINT [FK_SwProductCategory_categoryID] FOREIGN KEY ([categoryID]) REFERENCES [dbo].[SwCategory] ([categoryID])
GO
ALTER TABLE [dbo].[SwProductCategory] WITH NOCHECK ADD CONSTRAINT [FK_SwProductCategory_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwSkuLocationConfiguration] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuLocationConfiguration_locationConfigurationID] FOREIGN KEY ([locationConfigurationID]) REFERENCES [dbo].[SwLocationConfiguration] ([locationConfigurationID])
GO
ALTER TABLE [dbo].[SwSkuLocationConfiguration] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuLocationConfiguration_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwSkuOption] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuOption_optionID] FOREIGN KEY ([optionID]) REFERENCES [dbo].[SwOption] ([optionID])
GO
ALTER TABLE [dbo].[SwSkuOption] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuOption_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwOptionGroupProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwOptionGroupProductType_optionGroupID] FOREIGN KEY ([optionGroupID]) REFERENCES [dbo].[SwOptionGroup] ([optionGroupID])
GO
ALTER TABLE [dbo].[SwOptionGroupProductType] WITH NOCHECK ADD CONSTRAINT [FK_SwOptionGroupProductType_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwRelatedProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwRelatedProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwRelatedProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwRelatedProduct_relatedProductID] FOREIGN KEY ([relatedProductID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwPrivateLabelProgram] WITH NOCHECK ADD CONSTRAINT [FK_SwPrivateLabelProgram_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwSkuCommodityLink] WITH NOCHECK ADD CONSTRAINT [FK_SwSkuCommodityLink_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
