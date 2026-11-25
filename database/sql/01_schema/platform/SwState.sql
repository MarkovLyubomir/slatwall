/* =============================================================================
   Table: dbo.SwState
   Database: SlatwallCommerce
   Slatwall base entity: State
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwState] (
    [stateCode] CHAR(32) NOT NULL,
    [countryCode] CHAR(32) NOT NULL,
    [stateName] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwState] PRIMARY KEY CLUSTERED ([stateCode], [countryCode])
)
GO
