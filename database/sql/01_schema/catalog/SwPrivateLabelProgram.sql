/* =============================================================================
   Table: dbo.SwPrivateLabelProgram
   Database: SlatwallCommerce
   Fairhaven / Ironbark / Slatwall Pro programs
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPrivateLabelProgram] (
    [PrivateLabelCode] VARCHAR(10) NOT NULL,
    [ProgramName] VARCHAR(40) NOT NULL,
    [Category] VARCHAR(60) NULL,
    [TargetPenetrationPct] DECIMAL(5,2) NULL,
    [LaunchYear] SMALLINT NULL,
    [brandID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPrivateLabelProgram] PRIMARY KEY CLUSTERED ([PrivateLabelCode])
)
GO
