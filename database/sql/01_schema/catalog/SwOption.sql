/* =============================================================================
   Table: dbo.SwOption
   Database: SlatwallCommerce
   Slatwall base entity: Option
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOption] (
    [optionID] CHAR(32) NOT NULL,
    [optionCode] VARCHAR(255) NULL,
    [optionName] VARCHAR(255) NULL,
    [optionDescription] VARCHAR(4000) NULL,
    [sortOrder] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [optionGroupID] CHAR(32) NULL,
    [defaultImageID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOption] PRIMARY KEY CLUSTERED ([optionID])
)
GO
