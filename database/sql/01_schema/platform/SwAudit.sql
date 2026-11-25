/* =============================================================================
   Table: dbo.SwAudit
   Database: SlatwallCommerce
   Slatwall base entity: Audit
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAudit] (
    [auditID] CHAR(32) NOT NULL,
    [auditType] VARCHAR(255) NULL,
    [auditDateTime] DATETIME NULL,
    [auditArchiveStartDateTime] DATETIME NULL,
    [auditArchiveEndDateTime] DATETIME NULL,
    [auditArchiveCreatedDateTime] DATETIME NULL,
    [baseObject] VARCHAR(255) NULL,
    [baseID] VARCHAR(255) NULL,
    [data] VARCHAR(MAX) NULL,
    [title] VARCHAR(1000) NULL,
    [sessionIPAddress] VARCHAR(255) NULL,
    [sessionAccountID] VARCHAR(32) NULL,
    [sessionAccountEmailAddress] VARCHAR(255) NULL,
    [sessionAccountFullName] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwAudit] PRIMARY KEY CLUSTERED ([auditID])
)
GO
