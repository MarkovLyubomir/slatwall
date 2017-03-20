/* Foreign keys - stores domain. WITH NOCHECK: added 2017 after data cleanup, never re-validated (is_not_trusted = 1). */
ALTER TABLE [dbo].[SwLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwLocation_locationAddressID] FOREIGN KEY ([locationAddressID]) REFERENCES [dbo].[SwLocationAddress] ([locationAddressID])
GO
ALTER TABLE [dbo].[SwLocation] WITH NOCHECK ADD CONSTRAINT [FK_SwLocation_parentLocationID] FOREIGN KEY ([parentLocationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwLocationAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwLocationAddress_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwLocationAddress] WITH NOCHECK ADD CONSTRAINT [FK_SwLocationAddress_addressID] FOREIGN KEY ([addressID]) REFERENCES [dbo].[SwAddress] ([addressID])
GO
ALTER TABLE [dbo].[SwLocationConfiguration] WITH NOCHECK ADD CONSTRAINT [FK_SwLocationConfiguration_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwStoreProfile] WITH NOCHECK ADD CONSTRAINT [FK_SwStoreProfile_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwDistributionCenter] WITH NOCHECK ADD CONSTRAINT [FK_SwDistributionCenter_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
ALTER TABLE [dbo].[SwLocationZone] WITH NOCHECK ADD CONSTRAINT [FK_SwLocationZone_locationID] FOREIGN KEY ([locationID]) REFERENCES [dbo].[SwLocation] ([locationID])
GO
