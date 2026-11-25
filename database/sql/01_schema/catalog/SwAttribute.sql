/* =============================================================================
   Table: dbo.SwAttribute
   Database: SlatwallCommerce
   Slatwall base entity: Attribute
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAttribute] (
    [attributeID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [displayOnOrderDetailFlag] BIT NULL,
    [attributeName] VARCHAR(255) NULL,
    [attributeCode] VARCHAR(255) NULL,
    [attributeDescription] VARCHAR(4000) NULL,
    [attributeHint] VARCHAR(255) NULL,
    [attributeInputType] VARCHAR(255) NULL,
    [defaultValue] VARCHAR(255) NULL,
    [requiredFlag] BIT NULL,
    [sortOrder] INT NULL,
    [validationMessage] VARCHAR(255) NULL,
    [validationRegex] VARCHAR(255) NULL,
    [decryptValueInAdminFlag] BIT NULL,
    [relatedObject] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [typeSetID] CHAR(32) NULL,
    [attributeSetID] CHAR(32) NULL,
    [validationTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAttribute] PRIMARY KEY CLUSTERED ([attributeID])
)
GO
