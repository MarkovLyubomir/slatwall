/* =============================================================================
   Table: dbo.SwOptionGroup
   Database: SlatwallCommerce
   Slatwall base entity: OptionGroup
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOptionGroup] (
    [optionGroupID] CHAR(32) NOT NULL,
    [optionGroupName] VARCHAR(255) NULL,
    [optionGroupCode] VARCHAR(255) NULL,
    [optionGroupImage] VARCHAR(255) NULL,
    [optionGroupDescription] VARCHAR(4000) NULL,
    [imageGroupFlag] BIT NULL,
    [sortOrder] INT NULL,
    [globalFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwOptionGroup] PRIMARY KEY CLUSTERED ([optionGroupID])
)
GO
