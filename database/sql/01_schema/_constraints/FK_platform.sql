/* Foreign keys - platform domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwCountry] WITH NOCHECK ADD CONSTRAINT [FK_SwCountry_defaultCurrencyCode] FOREIGN KEY ([defaultCurrencyCode]) REFERENCES [dbo].[SwCurrency] ([currencyCode])
GO
ALTER TABLE [dbo].[SwCurrencyRate] WITH NOCHECK ADD CONSTRAINT [FK_SwCurrencyRate_currencyCode] FOREIGN KEY ([currencyCode]) REFERENCES [dbo].[SwCurrency] ([currencyCode])
GO
ALTER TABLE [dbo].[SwCurrencyRate] WITH NOCHECK ADD CONSTRAINT [FK_SwCurrencyRate_conversionCurrencyCode] FOREIGN KEY ([conversionCurrencyCode]) REFERENCES [dbo].[SwCurrency] ([currencyCode])
GO
ALTER TABLE [dbo].[SwImage] WITH NOCHECK ADD CONSTRAINT [FK_SwImage_imageTypeID] FOREIGN KEY ([imageTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwImage] WITH NOCHECK ADD CONSTRAINT [FK_SwImage_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwImage] WITH NOCHECK ADD CONSTRAINT [FK_SwImage_promotionID] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[SwPromotion] ([promotionID])
GO
ALTER TABLE [dbo].[SwImage] WITH NOCHECK ADD CONSTRAINT [FK_SwImage_optionID] FOREIGN KEY ([optionID]) REFERENCES [dbo].[SwOption] ([optionID])
GO
ALTER TABLE [dbo].[SwPermission] WITH NOCHECK ADD CONSTRAINT [FK_SwPermission_permissionGroupID] FOREIGN KEY ([permissionGroupID]) REFERENCES [dbo].[SwPermissionGroup] ([permissionGroupID])
GO
ALTER TABLE [dbo].[SwPostalCode] WITH NOCHECK ADD CONSTRAINT [FK_SwPostalCode_countryCode] FOREIGN KEY ([countryCode]) REFERENCES [dbo].[SwCountry] ([countryCode])
GO
ALTER TABLE [dbo].[SwPostalCode] WITH NOCHECK ADD CONSTRAINT [FK_SwPostalCode_stateCode,countryCode] FOREIGN KEY ([stateCode,countryCode]) REFERENCES [dbo].[SwState] ([countryCode])
GO
ALTER TABLE [dbo].[SwSession] WITH NOCHECK ADD CONSTRAINT [FK_SwSession_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwSession] WITH NOCHECK ADD CONSTRAINT [FK_SwSession_accountAuthenticationID] FOREIGN KEY ([accountAuthenticationID]) REFERENCES [dbo].[SwAccountAuthentication] ([accountAuthenticationID])
GO
ALTER TABLE [dbo].[SwSession] WITH NOCHECK ADD CONSTRAINT [FK_SwSession_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_emailID] FOREIGN KEY ([emailID]) REFERENCES [dbo].[SwEmail] ([emailID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_emailTemplateID] FOREIGN KEY ([emailTemplateID]) REFERENCES [dbo].[SwEmailTemplate] ([emailTemplateID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_fulfillmentMethodID] FOREIGN KEY ([fulfillmentMethodID]) REFERENCES [dbo].[SwFulfillmentMethod] ([fulfillmentMethodID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_locationConfigurationID] FOREIGN KEY ([locationConfigurationID]) REFERENCES [dbo].[SwLocationConfiguration] ([locationConfigurationID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_paymentMethodID] FOREIGN KEY ([paymentMethodID]) REFERENCES [dbo].[SwPaymentMethod] ([paymentMethodID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_productTypeID] FOREIGN KEY ([productTypeID]) REFERENCES [dbo].[SwProductType] ([productTypeID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_shippingMethodID] FOREIGN KEY ([shippingMethodID]) REFERENCES [dbo].[SwShippingMethod] ([shippingMethodID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_shippingMethodRateID] FOREIGN KEY ([shippingMethodRateID]) REFERENCES [dbo].[SwShippingMethodRate] ([shippingMethodRateID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwSetting] WITH NOCHECK ADD CONSTRAINT [FK_SwSetting_taskID] FOREIGN KEY ([taskID]) REFERENCES [dbo].[SwTask] ([taskID])
GO
ALTER TABLE [dbo].[SwTaskHistory] WITH NOCHECK ADD CONSTRAINT [FK_SwTaskHistory_taskID] FOREIGN KEY ([taskID]) REFERENCES [dbo].[SwTask] ([taskID])
GO
ALTER TABLE [dbo].[SwTaskHistory] WITH NOCHECK ADD CONSTRAINT [FK_SwTaskHistory_taskScheduleID] FOREIGN KEY ([taskScheduleID]) REFERENCES [dbo].[SwTaskSchedule] ([taskScheduleID])
GO
ALTER TABLE [dbo].[SwTaskSchedule] WITH NOCHECK ADD CONSTRAINT [FK_SwTaskSchedule_taskID] FOREIGN KEY ([taskID]) REFERENCES [dbo].[SwTask] ([taskID])
GO
ALTER TABLE [dbo].[SwType] WITH NOCHECK ADD CONSTRAINT [FK_SwType_parentTypeID] FOREIGN KEY ([parentTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAddressZoneLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwAddressZoneLocation_addressZoneID] FOREIGN KEY ([addressZoneID]) REFERENCES [dbo].[SwAddressZone] ([addressZoneID])
GO
ALTER TABLE [dbo].[SwAddressZoneLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwAddressZoneLocation_addressID] FOREIGN KEY ([addressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
