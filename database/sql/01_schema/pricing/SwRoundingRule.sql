/* =============================================================================
   Table: dbo.SwRoundingRule
   Database: SlatwallCommerce
   Slatwall base entity: RoundingRule
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwRoundingRule] (
    [roundingRuleID] CHAR(32) NOT NULL,
    [roundingRuleName] VARCHAR(255) NULL,
    [roundingRuleExpression] VARCHAR(255) NULL,
    [roundingRuleDirection] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwRoundingRule] PRIMARY KEY CLUSTERED ([roundingRuleID])
)
GO
