/* =============================================================================
   Table: dbo.SwEmailTemplate
   Database: SlatwallCommerce
   Slatwall base entity: EmailTemplate
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwEmailTemplate] (
    [emailTemplateID] CHAR(32) NOT NULL,
    [emailTemplateName] VARCHAR(255) NULL,
    [emailTemplateObject] VARCHAR(255) NULL,
    [emailTemplateFile] VARCHAR(255) NULL,
    [emailBodyHTML] VARCHAR(4000) NULL,
    [emailBodyText] VARCHAR(4000) NULL,
    [logEmailFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwEmailTemplate] PRIMARY KEY CLUSTERED ([emailTemplateID])
)
GO
