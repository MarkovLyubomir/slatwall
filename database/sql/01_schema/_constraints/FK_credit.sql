/* Foreign keys - credit domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryBillingAddressID] FOREIGN KEY ([primaryBillingAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryEmailAddressID] FOREIGN KEY ([primaryEmailAddressID]) REFERENCES [dbo].[SwAccountEmailAddress] ([accountEmailAddressID])
GO
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryPhoneNumberID] FOREIGN KEY ([primaryPhoneNumberID]) REFERENCES [dbo].[SwAccountPhoneNumber] ([accountPhoneNumberID])
GO
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryAddressID] FOREIGN KEY ([primaryAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryPaymentMethodID] FOREIGN KEY ([primaryPaymentMethodID]) REFERENCES [dbo].[SwAccountPaymentMethod] ([accountPaymentMethodID])
GO
ALTER TABLE [dbo].[SwAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwAccount_primaryShippingAddressID] FOREIGN KEY ([primaryShippingAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwAccountAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountAddress_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountAddress_addressID] FOREIGN KEY ([addressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwAccountAuthentication] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountAuthentication_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountAuthentication] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountAuthentication_integrationID] FOREIGN KEY ([integrationID]) REFERENCES [dbo].[SwIntegration] ([integrationID])
GO
ALTER TABLE [dbo].[SwAccountEmailAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountEmailAddress_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountEmailAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountEmailAddress_accountEmailTypeID] FOREIGN KEY ([accountEmailTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAccountLoyalty] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyalty_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountLoyalty] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyalty_loyaltyID] FOREIGN KEY ([loyaltyID]) REFERENCES [dbo].[SwLoyalty] ([loyaltyID])
GO
ALTER TABLE [dbo].[SwAccountLoyaltyTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyaltyTransaction_accountLoyaltyID] FOREIGN KEY ([accountLoyaltyID]) REFERENCES [dbo].[SwAccountLoyalty] ([accountLoyaltyID])
GO
ALTER TABLE [dbo].[SwAccountLoyaltyTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyaltyTransaction_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwAccountLoyaltyTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyaltyTransaction_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwAccountLoyaltyTransaction] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountLoyaltyTransaction_orderFulfillmentID] FOREIGN KEY ([orderFulfillmentID]) REFERENCES [dbo].[SwOrderFulfillment] ([orderFulfillmentID])
GO
ALTER TABLE [dbo].[SwAccountPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPayment_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPayment_accountPaymentMethodID] FOREIGN KEY ([accountPaymentMethodID]) REFERENCES [dbo].[SwAccountPaymentMethod] ([accountPaymentMethodID])
GO
ALTER TABLE [dbo].[SwAccountPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPayment_accountPaymentTypeID] FOREIGN KEY ([accountPaymentTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAccountPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPayment_billingAddressID] FOREIGN KEY ([billingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwAccountPayment] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPayment_paymentMethodID] FOREIGN KEY ([paymentMethodID]) REFERENCES [dbo].[SwPaymentMethod] ([paymentMethodID])
GO
ALTER TABLE [dbo].[SwAccountPaymentApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentApplied_accountPaymentID] FOREIGN KEY ([accountPaymentID]) REFERENCES [dbo].[SwAccountPayment] ([accountPaymentID])
GO
ALTER TABLE [dbo].[SwAccountPaymentApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentApplied_orderPaymentID] FOREIGN KEY ([orderPaymentID]) REFERENCES [dbo].[SwOrderPayment] ([orderPaymentID])
GO
ALTER TABLE [dbo].[SwAccountPaymentApplied] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentApplied_accountPaymentTypeID] FOREIGN KEY ([accountPaymentTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAccountPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentMethod_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentMethod_billingAccountAddressID] FOREIGN KEY ([billingAccountAddressID]) REFERENCES [dbo].[SwAccountAddress] ([accountAddressID])
GO
ALTER TABLE [dbo].[SwAccountPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentMethod_billingAddressID] FOREIGN KEY ([billingAddressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwAccountPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentMethod_paymentMethodID] FOREIGN KEY ([paymentMethodID]) REFERENCES [dbo].[SwPaymentMethod] ([paymentMethodID])
GO
ALTER TABLE [dbo].[SwAccountPaymentMethod] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPaymentMethod_paymentTermID] FOREIGN KEY ([paymentTermID]) REFERENCES [dbo].[SwPaymentTerm] ([paymentTermID])
GO
ALTER TABLE [dbo].[SwAccountPhoneNumber] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPhoneNumber_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountPhoneNumber] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPhoneNumber_accountPhoneTypeID] FOREIGN KEY ([accountPhoneTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwAccountRelationship] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountRelationship_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountRelationship] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountRelationship_relatedAccountID] FOREIGN KEY ([relatedAccountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountRelationship] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountRelationship_relationshipTypeID] FOREIGN KEY ([relationshipTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwPaymentTerm] WITH NOCHECK ADD CONSTRAINT [FK_SwPaymentTerm_termID] FOREIGN KEY ([termID]) REFERENCES [dbo].[SwTerm] ([termID])
GO
ALTER TABLE [dbo].[SwAccountPriceGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPriceGroup_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountPriceGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPriceGroup_priceGroupID] FOREIGN KEY ([priceGroupID]) REFERENCES [dbo].[SwPriceGroup] ([priceGroupID])
GO
ALTER TABLE [dbo].[SwAccountPermissionGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPermissionGroup_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwAccountPermissionGroup] WITH NOCHECK ADD CONSTRAINT [FK_SwAccountPermissionGroup_permissionGroupID] FOREIGN KEY ([permissionGroupID]) REFERENCES [dbo].[SwPermissionGroup] ([permissionGroupID])
GO
ALTER TABLE [dbo].[SwProAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwProAccount_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwJobAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwJobAccount_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwCreditApplication] WITH NOCHECK ADD CONSTRAINT [FK_SwCreditApplication_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwCreditLimit] WITH NOCHECK ADD CONSTRAINT [FK_SwCreditLimit_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwCreditLimit] WITH NOCHECK ADD CONSTRAINT [FK_SwCreditLimit_JobAccountID] FOREIGN KEY ([JobAccountID]) REFERENCES [dbo].[SwJobAccount] ([JobAccountID])
GO
ALTER TABLE [dbo].[SwCreditHold] WITH NOCHECK ADD CONSTRAINT [FK_SwCreditHold_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwDunningEvent] WITH NOCHECK ADD CONSTRAINT [FK_SwDunningEvent_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwLienNotice] WITH NOCHECK ADD CONSTRAINT [FK_SwLienNotice_JobAccountID] FOREIGN KEY ([JobAccountID]) REFERENCES [dbo].[SwJobAccount] ([JobAccountID])
GO
ALTER TABLE [dbo].[SwARInvoice] WITH NOCHECK ADD CONSTRAINT [FK_SwARInvoice_ProAccountID] FOREIGN KEY ([ProAccountID]) REFERENCES [dbo].[SwProAccount] ([ProAccountID])
GO
ALTER TABLE [dbo].[SwARInvoice] WITH NOCHECK ADD CONSTRAINT [FK_SwARInvoice_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
