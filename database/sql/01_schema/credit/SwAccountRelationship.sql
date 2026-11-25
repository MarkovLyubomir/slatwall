/* =============================================================================
   Table: dbo.SwAccountRelationship
   Database: SlatwallCommerce
   Slatwall base entity: AccountRelationship
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountRelationship] (
    [accountRelationshipID] CHAR(32) NOT NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountID] CHAR(32) NULL,
    [relatedAccountID] CHAR(32) NULL,
    [relationshipTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountRelationship] PRIMARY KEY CLUSTERED ([accountRelationshipID])
)
GO
