/* =============================================================================
   Table: dbo.SwType
   Database: SlatwallCommerce
   Slatwall base entity: Type
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwType] (
    [typeID] CHAR(32) NOT NULL,
    [typeIDPath] VARCHAR(4000) NULL,
    [typeName] VARCHAR(255) NULL,
    [typeCode] VARCHAR(255) NULL,
    [typeDescription] VARCHAR(4000) NULL,
    [sortOrder] INT NULL,
    [systemCode] VARCHAR(255) NULL,
    [childRequiresSystemCodeFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [parentTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwType] PRIMARY KEY CLUSTERED ([typeID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwType_systemCode] ON [dbo].[SwType] ([systemCode])
GO

CREATE NONCLUSTERED INDEX [IX_SwType_parentTypeID] ON [dbo].[SwType] ([parentTypeID])
GO
