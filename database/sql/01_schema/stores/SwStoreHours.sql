/* =============================================================================
   Table: dbo.SwStoreHours
   Database: SlatwallCommerce
   Store/yard hours; no FK to SwStoreProfile
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwStoreHours] (
    [StoreHoursID] INT IDENTITY(1,1) NOT NULL,
    [StoreNumber] TINYINT NOT NULL,
    [DayOfWeek] TINYINT NOT NULL,
    [OpenTime] TIME NULL,
    [CloseTime] TIME NULL,
    [YardCloseTime] TIME NULL,
    [HolidayFlag] BIT NOT NULL CONSTRAINT [DF_SwStoreHours_HolidayFlag] DEFAULT (0),
    CONSTRAINT [PK_SwStoreHours] PRIMARY KEY CLUSTERED ([StoreHoursID])
)
GO
