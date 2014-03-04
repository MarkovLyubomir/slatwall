/* =============================================================================
   Table: dbo.SwReport
   Database: SlatwallCommerce
   Slatwall base entity: Report
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwReport] (
    [reportID] CHAR(32) NOT NULL,
    [reportName] VARCHAR(255) NULL,
    [reportTitle] VARCHAR(255) NULL,
    [reportDateTime] VARCHAR(255) NULL,
    [reportDateTimeGroupBy] VARCHAR(255) NULL,
    [reportCompareFlag] BIT NULL,
    [metrics] VARCHAR(4000) NULL,
    [dimensions] VARCHAR(4000) NULL,
    [dynamicDateRangeFlag] BIT NULL,
    [dynamicDateRangeType] VARCHAR(255) NULL,
    [dynamicDateRangeEndType] VARCHAR(255) NULL,
    [dynamicDateRangeInterval] INT NULL,
    [reportType] VARCHAR(255) NULL,
    [limitResults] INT NULL,
    [showReport] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwReport] PRIMARY KEY CLUSTERED ([reportID])
)
GO
