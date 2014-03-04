/* =============================================================================
   Table: dbo.SwAttributeSet
   Database: SlatwallCommerce
   Slatwall base entity: AttributeSet
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAttributeSet] (
    [attributeSetID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [attributeSetName] VARCHAR(255) NULL,
    [attributeSetCode] VARCHAR(255) NULL,
    [attributeSetDescription] VARCHAR(2000) NULL,
    [attributeSetObject] VARCHAR(255) NULL,
    [globalFlag] BIT NULL,
    [accountSaveFlag] BIT NULL,
    [sortOrder] INT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwAttributeSet] PRIMARY KEY CLUSTERED ([attributeSetID])
)
GO
