/* =============================================================================
   Table: dbo.SwAttributeOption
   Database: SlatwallCommerce
   Slatwall base entity: AttributeOption
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAttributeOption] (
    [attributeOptionID] CHAR(32) NOT NULL,
    [attributeOptionValue] VARCHAR(255) NULL,
    [attributeOptionLabel] VARCHAR(255) NULL,
    [sortOrder] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [attributeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAttributeOption] PRIMARY KEY CLUSTERED ([attributeOptionID])
)
GO
