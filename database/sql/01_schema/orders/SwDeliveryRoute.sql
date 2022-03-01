/* =============================================================================
   Table: dbo.SwDeliveryRoute
   Database: SlatwallCommerce
   Delivery routes (Descartes feed, T11)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwDeliveryRoute] (
    [DeliveryRouteID] INT IDENTITY(1,1) NOT NULL,
    [RouteDate] DATE NOT NULL,
    [OriginType] CHAR(2) NOT NULL,
    [OriginNumber] TINYINT NOT NULL,
    [TruckType] VARCHAR(10) NOT NULL,
    [TruckNo] VARCHAR(10) NULL,
    [DriverUser] VARCHAR(50) NULL,
    [DescartesRouteRef] VARCHAR(40) NULL,
    [PlannedStops] TINYINT NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwDeliveryRoute_Status] DEFAULT ('PLANNED'),
    [DepartedOn] DATETIME NULL,
    [ReturnedOn] DATETIME NULL,
    [TotalMiles] DECIMAL(8,1) NULL,
    CONSTRAINT [PK_SwDeliveryRoute] PRIMARY KEY CLUSTERED ([DeliveryRouteID])
)
GO
