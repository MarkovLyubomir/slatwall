/* =============================================================================
   Table: dbo.SwEmail
   Database: SlatwallCommerce
   Slatwall base entity: Email
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwEmail] (
    [emailID] CHAR(32) NOT NULL,
    [emailTo] VARCHAR(255) NULL,
    [emailFrom] VARCHAR(255) NULL,
    [emailFailTo] VARCHAR(255) NULL,
    [emailCC] VARCHAR(255) NULL,
    [emailBCC] VARCHAR(255) NULL,
    [emailSubject] VARCHAR(255) NULL,
    [emailBodyHTML] VARCHAR(MAX) NULL,
    [emailBodyText] VARCHAR(MAX) NULL,
    [relatedObject] VARCHAR(255) NULL,
    [relatedObjectID] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwEmail] PRIMARY KEY CLUSTERED ([emailID])
)
GO
