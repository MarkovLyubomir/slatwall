/* =============================================================================
   Table: dbo.SwVendorScorecard
   Database: SlatwallCommerce
   Vendor scorecard (T10)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwVendorScorecard] (
    [VendorScorecardID] INT IDENTITY(1,1) NOT NULL,
    [vendorID] CHAR(32) NOT NULL,
    [FiscalYear] SMALLINT NOT NULL,
    [FiscalPeriod] TINYINT NOT NULL,
    [POCount] INT NULL,
    [LinesOrdered] INT NULL,
    [LinesFilled] INT NULL,
    [FillRatePct] DECIMAL(5,2) NULL,
    [OnTimePct] DECIMAL(5,2) NULL,
    [ChargebackCount] INT NULL,
    [ChargebackAmt] DECIMAL(19,2) NULL,
    [PriceChangeNotices] SMALLINT NULL,
    [Score] DECIMAL(5,2) NULL,
    [Grade] CHAR(1) NULL,
    [CalculatedOn] DATETIME NULL,
    CONSTRAINT [PK_SwVendorScorecard] PRIMARY KEY CLUSTERED ([VendorScorecardID])
)
GO
