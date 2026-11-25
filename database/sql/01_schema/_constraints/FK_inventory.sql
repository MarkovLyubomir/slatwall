/* Foreign keys - inventory domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwInventory] WITH NOCHECK ADD CONSTRAINT [FK_SwInventory_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwInventory] WITH NOCHECK ADD CONSTRAINT [FK_SwInventory_stockReceiverItemID] FOREIGN KEY ([stockReceiverItemID]) REFERENCES [dbo].[SwStockReceiverItem] ([stockReceiverItemID])
GO
ALTER TABLE [dbo].[SwInventory] WITH NOCHECK ADD CONSTRAINT [FK_SwInventory_orderDeliveryItemID] FOREIGN KEY ([orderDeliveryItemID]) REFERENCES [dbo].[SwOrderDeliveryItem] ([orderDeliveryItemID])
GO
ALTER TABLE [dbo].[SwInventory] WITH NOCHECK ADD CONSTRAINT [FK_SwInventory_stockAdjustmentDeliveryItemID] FOREIGN KEY ([stockAdjustmentDeliveryItemID]) REFERENCES [dbo].[SwStockAdjustmentDeliveryItem] ([stockAdjustmentDeliveryItemID])
GO
ALTER TABLE [dbo].[SwPhysical] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysical_physicalStatusTypeID] FOREIGN KEY ([physicalStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwPhysicalCount] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalCount_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwPhysicalCount] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalCount_physicalID] FOREIGN KEY ([physicalID]) REFERENCES [dbo].[SwPhysical] ([physicalID])
GO
ALTER TABLE [dbo].[SwPhysicalCountItem] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalCountItem_physicalCountID] FOREIGN KEY ([physicalCountID]) REFERENCES [dbo].[SwPhysicalCount] ([physicalCountID])
GO
ALTER TABLE [dbo].[SwPhysicalCountItem] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalCountItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStock] WITH NOCHECK ADD CONSTRAINT [FK_SwStock_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwStock] WITH NOCHECK ADD CONSTRAINT [FK_SwStock_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwStockAdjustment] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustment_fromLocationID] FOREIGN KEY ([fromLocationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwStockAdjustment] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustment_toLocationID] FOREIGN KEY ([toLocationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwStockAdjustment] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustment_stockAdjustmentTypeID] FOREIGN KEY ([stockAdjustmentTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwStockAdjustment] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustment_stockAdjustmentStatusTypeID] FOREIGN KEY ([stockAdjustmentStatusTypeID]) REFERENCES [dbo].[SwType] ([typeID])
GO
ALTER TABLE [dbo].[SwStockAdjustment] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustment_physicalID] FOREIGN KEY ([physicalID]) REFERENCES [dbo].[SwPhysical] ([physicalID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentDelivery] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentDelivery_stockAdjustmentID] FOREIGN KEY ([stockAdjustmentID]) REFERENCES [dbo].[SwStockAdjustment] ([stockAdjustmentID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentDeliveryItem_stockAdjustmentDeliveryID] FOREIGN KEY ([stockAdjustmentDeliveryID]) REFERENCES [dbo].[SwStockAdjustmentDelivery] ([stockAdjustmentDeliveryID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentDeliveryItem_stockAdjustmentItemID] FOREIGN KEY ([stockAdjustmentItemID]) REFERENCES [dbo].[SwStockAdjustmentItem] ([stockAdjustmentItemID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentDeliveryItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentDeliveryItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentItem_stockAdjustmentID] FOREIGN KEY ([stockAdjustmentID]) REFERENCES [dbo].[SwStockAdjustment] ([stockAdjustmentID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentItem_fromStockID] FOREIGN KEY ([fromStockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentItem_toStockID] FOREIGN KEY ([toStockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStockAdjustmentItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockAdjustmentItem_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwStockHold] WITH NOCHECK ADD CONSTRAINT [FK_SwStockHold_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwStockHold] WITH NOCHECK ADD CONSTRAINT [FK_SwStockHold_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwStockHold] WITH NOCHECK ADD CONSTRAINT [FK_SwStockHold_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStockReceiver] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiver_orderID] FOREIGN KEY ([orderID]) REFERENCES [dbo].[SwOrder] ([orderID])
GO
ALTER TABLE [dbo].[SwStockReceiver] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiver_stockAdjustmentID] FOREIGN KEY ([stockAdjustmentID]) REFERENCES [dbo].[SwStockAdjustment] ([stockAdjustmentID])
GO
ALTER TABLE [dbo].[SwStockReceiver] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiver_vendorOrderID] FOREIGN KEY ([vendorOrderID]) REFERENCES [dbo].[SwVendorOrder] ([vendorOrderID])
GO
ALTER TABLE [dbo].[SwStockReceiverItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiverItem_stockID] FOREIGN KEY ([stockID]) REFERENCES [dbo].[SwStock] ([stockID])
GO
ALTER TABLE [dbo].[SwStockReceiverItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiverItem_stockReceiverID] FOREIGN KEY ([stockReceiverID]) REFERENCES [dbo].[SwStockReceiver] ([stockReceiverID])
GO
ALTER TABLE [dbo].[SwStockReceiverItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiverItem_orderItemID] FOREIGN KEY ([orderItemID]) REFERENCES [dbo].[SwOrderItem] ([orderItemID])
GO
ALTER TABLE [dbo].[SwStockReceiverItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiverItem_vendorOrderItemID] FOREIGN KEY ([vendorOrderItemID]) REFERENCES [dbo].[SwVendorOrderItem] ([vendorOrderItemID])
GO
ALTER TABLE [dbo].[SwStockReceiverItem] WITH NOCHECK ADD CONSTRAINT [FK_SwStockReceiverItem_stockAdjustmentItemID] FOREIGN KEY ([stockAdjustmentItemID]) REFERENCES [dbo].[SwStockAdjustmentItem] ([stockAdjustmentItemID])
GO
ALTER TABLE [dbo].[SwPhysicalLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalLocation_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwPhysicalLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwPhysicalLocation_physicalID] FOREIGN KEY ([physicalID]) REFERENCES [dbo].[SwPhysical] ([physicalID])
GO
ALTER TABLE [dbo].[SwASN] WITH NOCHECK ADD CONSTRAINT [FK_SwASN_vendorID] FOREIGN KEY ([vendorID]) REFERENCES [dbo].[SwVendor] ([vendorID])
GO
ALTER TABLE [dbo].[SwASN] WITH NOCHECK ADD CONSTRAINT [FK_SwASN_vendorOrderID] FOREIGN KEY ([vendorOrderID]) REFERENCES [dbo].[SwVendorOrder] ([vendorOrderID])
GO
ALTER TABLE [dbo].[SwASNLine] WITH NOCHECK ADD CONSTRAINT [FK_SwASNLine_ASNID] FOREIGN KEY ([ASNID]) REFERENCES [dbo].[SwASN] ([ASNID])
GO
ALTER TABLE [dbo].[SwASNLine] WITH NOCHECK ADD CONSTRAINT [FK_SwASNLine_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
ALTER TABLE [dbo].[SwReceivingException] WITH NOCHECK ADD CONSTRAINT [FK_SwReceivingException_stockReceiverItemID] FOREIGN KEY ([stockReceiverItemID]) REFERENCES [dbo].[SwStockReceiverItem] ([stockReceiverItemID])
GO
ALTER TABLE [dbo].[SwCycleCountSchedule] WITH NOCHECK ADD CONSTRAINT [FK_SwCycleCountSchedule_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwCycleCountSchedule] WITH NOCHECK ADD CONSTRAINT [FK_SwCycleCountSchedule_skuID] FOREIGN KEY ([skuID]) REFERENCES [dbo].[SwSku] ([skuID])
GO
