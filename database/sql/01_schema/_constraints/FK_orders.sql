/* Foreign keys - orders domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwGiftCard] WITH NOCHECK ADD CONSTRAINT [FK_SwGiftCard_originalOrderItemID] FOREIGN KEY ([originalOrderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwGiftCard] WITH NOCHECK ADD CONSTRAINT [FK_SwGiftCard_giftCardExpirationTermID] FOREIGN KEY ([giftCardExpirationTermID]) REFERENCES [dbo].[SwTerm] ([termID])
GO
ALTER TABLE [dbo].[SwGiftCard] WITH NOCHECK ADD CONSTRAINT [FK_SwGiftCard_ownerAccountID] FOREIGN KEY ([ownerAccountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwGiftCardTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwGiftCardTransaction_orderPaymentID] FOREIGN KEY ([orderPaymentID]) REFERENCES [dbo].[SwOrderPayment] ([orderPaymentID])
GO
ALTER TABLE [dbo].[SwGiftCardTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwGiftCardTransaction_giftCardID] FOREIGN KEY ([giftCardID]) REFERENCES [dbo].[SwGiftCard] ([giftCardID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_assignedAccountID] FOREIGN KEY ([assignedAccountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_billingAccountAddressID] FOREIGN KEY ([billingAccountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_billingAddressID] FOREIGN KEY ([billingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_orderTypeID] FOREIGN KEY ([orderTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_orderStatusTypeID] FOREIGN KEY ([orderStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_orderOriginID] FOREIGN KEY ([orderOriginID]) REFERENCES [dbo].[SwOrderOrigin] ([orderOriginID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_referencedOrderID] FOREIGN KEY ([referencedOrderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_shippingAccountAddressID] FOREIGN KEY ([shippingAccountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwOrder_shippingAddressID] FOREIGN KEY ([shippingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_fulfillmentMethodID] FOREIGN KEY ([fulfillmentMethodID]) REFERENCES [dbo].[SwFulfillmentMethod] ([fulfillmentMethodID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_shippingMethodID] FOREIGN KEY ([shippingMethodID]) REFERENCES [dbo].[SwShippingMethod] ([shippingMethodID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_shippingAddressID] FOREIGN KEY ([shippingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwOrderDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDelivery_paymentTransactionID] FOREIGN KEY ([paymentTransactionID]) REFERENCES [dbo].[SwPaymentTransaction] ([paymentTransactionID])
GO
ALTER TABLE [dbo].[SwOrderDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDeliveryItem_orderDeliveryID] FOREIGN KEY ([orderDeliveryID]) REFERENCES [dbo].[SwOrderDelivery] ([orderDeliveryID])
GO
ALTER TABLE [dbo].[SwOrderDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDeliveryItem_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwOrderDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderDeliveryItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_accountAddressID] FOREIGN KEY ([accountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_accountEmailAddressID] FOREIGN KEY ([accountEmailAddressID]) REFERENCES [dbo].[SwAccountEmailAddress] ([accountEmailAddressID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_fulfillmentMethodID] FOREIGN KEY ([fulfillmentMethodID]) REFERENCES [dbo].[SwFulfillmentMethod] ([fulfillmentMethodID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_shippingAddressID] FOREIGN KEY ([shippingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_shippingMethodID] FOREIGN KEY ([shippingMethodID]) REFERENCES [dbo].[SwShippingMethod] ([shippingMethodID])
GO
ALTER TABLE [dbo].[SwOrderFulfillment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderFulfillment_orderFulfillmentStatusTypeID] FOREIGN KEY ([orderFulfillmentStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_appliedPriceGroupID] FOREIGN KEY ([appliedPriceGroupID]) REFERENCES [dbo].[SwPriceGroup] ([priceGroupID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_orderItemTypeID] FOREIGN KEY ([orderItemTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_orderItemStatusTypeID] FOREIGN KEY ([orderItemStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_orderFulfillmentID] FOREIGN KEY ([orderFulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_orderReturnID] FOREIGN KEY ([orderReturnID]) REFERENCES [dbo].[SwOrderReturn] ([orderReturnID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_parentOrderItemID] FOREIGN KEY ([parentOrderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_productBundleGroupID] FOREIGN KEY ([productBundleGroupID]) REFERENCES [dbo].[SwProductBundleGroup] ([productBundleGroupID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_referencedOrderItemID] FOREIGN KEY ([referencedOrderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_giftCardTransactionID] FOREIGN KEY ([giftCardTransactionID]) REFERENCES [dbo].[SwGiftCardTransaction] ([giftCardTransactionID])
GO
ALTER TABLE [dbo].[SwOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderItem_referencedOrderDeliveryItemID] FOREIGN KEY ([referencedOrderDeliveryItemID]) REFERENCES [dbo].[SwOrderDeliveryItem] ([orderDeliveryItemID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_accountPaymentMethodID] FOREIGN KEY ([accountPaymentMethodID]) REFERENCES [dbo].[SwAccountPaymentMethod] ([accountPaymentMethodID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_billingAccountAddressID] FOREIGN KEY ([billingAccountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_billingAddressID] FOREIGN KEY ([billingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_orderPaymentTypeID] FOREIGN KEY ([orderPaymentTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_orderPaymentStatusTypeID] FOREIGN KEY ([orderPaymentStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_paymentMethodID] FOREIGN KEY ([paymentMethodID]) REFERENCES [dbo].[SwPaymentMethod] ([paymentMethodID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_paymentTermID] FOREIGN KEY ([paymentTermID]) REFERENCES [dbo].[SwPaymentTerm] ([paymentTermID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_referencedOrderPaymentID] FOREIGN KEY ([referencedOrderPaymentID]) REFERENCES [dbo].[SwOrderPayment] ([orderPaymentID])
GO
ALTER TABLE [dbo].[SwOrderPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPayment_termPaymentAccountID] FOREIGN KEY ([termPaymentAccountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwOrderReturn] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderReturn_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderReturn] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderReturn_returnLocationID] FOREIGN KEY ([returnLocationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwPaymentMethod_paymentIntegrationID] FOREIGN KEY ([paymentIntegrationID]) REFERENCES [dbo].[SwIntegration] ([integrationID])
GO
ALTER TABLE [dbo].[SwPaymentTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwPaymentTransaction_accountPaymentID] FOREIGN KEY ([accountPaymentID]) REFERENCES [dbo].[SwAccountPayment] ([accountPaymentID])
GO
ALTER TABLE [dbo].[SwPaymentTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwPaymentTransaction_accountPaymentMethodID] FOREIGN KEY ([accountPaymentMethodID]) REFERENCES [dbo].[SwAccountPaymentMethod] ([accountPaymentMethodID])
GO
ALTER TABLE [dbo].[SwPaymentTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwPaymentTransaction_orderPaymentID] FOREIGN KEY ([orderPaymentID]) REFERENCES [dbo].[SwOrderPayment] ([orderPaymentID])
GO
ALTER TABLE [dbo].[SwShippingMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethod_fulfillmentMethodID] FOREIGN KEY ([fulfillmentMethodID]) REFERENCES [dbo].[SwFulfillmentMethod] ([fulfillmentMethodID])
GO
ALTER TABLE [dbo].[SwShippingMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethod_addressZoneID] FOREIGN KEY ([addressZoneID]) REFERENCES [dbo].[SwAddressZone] ([addressZoneID])
GO
ALTER TABLE [dbo].[SwShippingMethodOption] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethodOption_shippingMethodRateID] FOREIGN KEY ([shippingMethodRateID]) REFERENCES [dbo].[SwShippingMethodRate] ([shippingMethodRateID])
GO
ALTER TABLE [dbo].[SwShippingMethodOption] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethodOption_orderFulfillmentID] FOREIGN KEY ([orderFulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwShippingMethodRate] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethodRate_shippingIntegrationID] FOREIGN KEY ([shippingIntegrationID]) REFERENCES [dbo].[SwIntegration] ([integrationID])
GO
ALTER TABLE [dbo].[SwShippingMethodRate] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethodRate_shippingMethodID] FOREIGN KEY ([shippingMethodID]) REFERENCES [dbo].[SwShippingMethod] ([shippingMethodID])
GO
ALTER TABLE [dbo].[SwShippingMethodRate] WITH NOCHECK ADD CONSTRAINT [FK_SwShippingMethodRate_addressZoneID] FOREIGN KEY ([addressZoneID]) REFERENCES [dbo].[SwAddressZone] ([addressZoneID])
GO
ALTER TABLE [dbo].[SwOrderPromotionCode] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPromotionCode_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwOrderPromotionCode] WITH NOCHECK ADD CONSTRAINT [FK_SwOrderPromotionCode_promotionCodeID] FOREIGN KEY ([promotionCodeID]) REFERENCES [dbo].[SwPromotionCode] ([promotionCodeID])
GO
ALTER TABLE [dbo].[SwPickTask] WITH NOCHECK ADD CONSTRAINT [FK_SwPickTask_orderFulfillmentID] FOREIGN KEY ([orderFulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwWillCallRelease] WITH NOCHECK ADD CONSTRAINT [FK_SwWillCallRelease_JobAccountID] FOREIGN KEY ([JobAccountID]) REFERENCES [dbo].[SwJobAccount] ([JobAccountID])
GO
ALTER TABLE [dbo].[SwWillCallRelease] WITH NOCHECK ADD CONSTRAINT [FK_SwWillCallRelease_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwDeliveryStop] WITH NOCHECK ADD CONSTRAINT [FK_SwDeliveryStop_DeliveryRouteID] FOREIGN KEY ([DeliveryRouteID]) REFERENCES [dbo].[SwDeliveryRoute] ([DeliveryRouteID])
GO
ALTER TABLE [dbo].[SwDeliveryStop] WITH NOCHECK ADD CONSTRAINT [FK_SwDeliveryStop_orderDeliveryID] FOREIGN KEY ([orderDeliveryID]) REFERENCES [dbo].[SwOrderDelivery] ([orderDeliveryID])
GO
ALTER TABLE [dbo].[SwDeliveryStop] WITH NOCHECK ADD CONSTRAINT [FK_SwDeliveryStop_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwRMA] WITH NOCHECK ADD CONSTRAINT [FK_SwRMA_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwRMA] WITH NOCHECK ADD CONSTRAINT [FK_SwRMA_orderReturnID] FOREIGN KEY ([orderReturnID]) REFERENCES [dbo].[SwOrderReturn] ([orderReturnID])
GO
