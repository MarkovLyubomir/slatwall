/* Foreign keys - vendors domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwVendor] WITH NOCHECK ADD CONSTRAINT [FK_SwVendor_primaryEmailAddressID] FOREIGN KEY ([primaryEmailAddressID]) REFERENCES [dbo].[SwVendorEmailAddress] ([vendorEmailAddressID])
GO
ALTER TABLE [dbo].[SwVendor] WITH NOCHECK ADD CONSTRAINT [FK_SwVendor_primaryPhoneNumberID] FOREIGN KEY ([primaryPhoneNumberID]) REFERENCES [dbo].[SwVendorPhoneNumber] ([vendorPhoneNumberID])
GO
ALTER TABLE [dbo].[SwVendor] WITH NOCHECK ADD CONSTRAINT [FK_SwVendor_primaryAddressID] FOREIGN KEY ([primaryAddressID]) REFERENCES [dbo].[SwVendorAddress] ([vendorAddressID])
GO
ALTER TABLE [dbo].[SwVendorAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorAccount_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorAccount_accountID] FOREIGN KEY ([accountID]) REFERENCES [dbo].[SwAccount] ([accountID])
GO
ALTER TABLE [dbo].[SwVendorAccount] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorAccount_roleTypeID] FOREIGN KEY ([roleTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwVendorAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorAddress_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorAddress_addressID] FOREIGN KEY ([addressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwVendorEmailAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorEmailAddress_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrder_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwVendorOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrder_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrder_vendorOrderTypeID] FOREIGN KEY ([vendorOrderTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwVendorOrder] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrder_vendorOrderStatusTypeID] FOREIGN KEY ([vendorOrderStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwVendorOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrderItem_vendorOrderItemTypeID] FOREIGN KEY ([vendorOrderItemTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwVendorOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrderItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwVendorOrderItem] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorOrderItem_vendorOrderID] FOREIGN KEY ([vendorOrderID]) REFERENCES [dbo].[SwVendorOrder] ([vendorOrderID])
GO
ALTER TABLE [dbo].[SwVendorPhoneNumber] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorPhoneNumber_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorSkuStock] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorSkuStock_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwVendorSkuStock] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorSkuStock_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorBrand_brandID] FOREIGN KEY ([brandID]) REFERENCES [dbo].[SwBrand] ([brandID])
GO
ALTER TABLE [dbo].[SwVendorBrand] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorBrand_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorProduct_productID] FOREIGN KEY ([productID]) REFERENCES [dbo].[SwProduct] ([productID])
GO
ALTER TABLE [dbo].[SwVendorProduct] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorProduct_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwVendorScorecard] WITH NOCHECK ADD CONSTRAINT [FK_SwVendorScorecard_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
