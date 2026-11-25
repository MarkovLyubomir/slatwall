/* =============================================================================
   Table: dbo.SwTerm
   Database: SlatwallCommerce
   Slatwall base entity: Term
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwTerm] (
    [termID] CHAR(32) NOT NULL,
    [termName] VARCHAR(255) NULL,
    [termHours] INT NULL,
    [termDays] INT NULL,
    [termMonths] INT NULL,
    [termYears] INT NULL,
    [sortOrder] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwTerm] PRIMARY KEY CLUSTERED ([termID])
)
GO
