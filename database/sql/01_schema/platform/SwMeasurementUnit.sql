/* =============================================================================
   Table: dbo.SwMeasurementUnit
   Database: SlatwallCommerce
   Slatwall base entity: MeasurementUnit
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwMeasurementUnit] (
    [unitCode] CHAR(32) NOT NULL,
    [measurementType] VARCHAR(255) NULL,
    [unitName] VARCHAR(255) NULL,
    [conversionRatio] FLOAT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwMeasurementUnit] PRIMARY KEY CLUSTERED ([unitCode])
)
GO
