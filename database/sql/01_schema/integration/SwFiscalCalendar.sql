/* =============================================================================
   Table: dbo.SwFiscalCalendar
   Database: SlatwallCommerce
   Fiscal calendar (FY = 1 Feb - 31 Jan)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwFiscalCalendar] (
    [CalendarDate] DATE NOT NULL,
    [FiscalYear] SMALLINT NOT NULL,
    [FiscalPeriod] TINYINT NOT NULL,
    [FiscalWeek] TINYINT NOT NULL,
    [FiscalQuarter] TINYINT NOT NULL,
    [DayOfWeek] TINYINT NOT NULL,
    [HolidayFlag] BIT NULL CONSTRAINT [DF_SwFiscalCalendar_HolidayFlag] DEFAULT (0),
    [CompWeekDate] DATE NULL,
    CONSTRAINT [PK_SwFiscalCalendar] PRIMARY KEY CLUSTERED ([CalendarDate])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwFiscalCalendar_FY_Week] ON [dbo].[SwFiscalCalendar] ([FiscalYear], [FiscalWeek])
GO
