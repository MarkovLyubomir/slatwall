/* =============================================================================
   Table: dbo.SwMarkdownAuthority
   Database: SlatwallCommerce
   T2 authority matrix (ignored by most procs)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwMarkdownAuthority] (
    [MarkdownAuthorityID] INT IDENTITY(1,1) NOT NULL,
    [RoleCode] VARCHAR(20) NOT NULL,
    [MaxMarkdownPct] DECIMAL(5,2) NOT NULL,
    [MinMarginPct] DECIMAL(5,2) NOT NULL,
    [MaxLineAmount] DECIMAL(19,2) NULL,
    [RequiresSecondApproval] BIT NOT NULL CONSTRAINT [DF_SwMarkdownAuthority_RequiresSecondApproval] DEFAULT (0),
    [EffectiveDate] DATE NOT NULL,
    [PolicyRef] VARCHAR(20) NULL CONSTRAINT [DF_SwMarkdownAuthority_PolicyRef] DEFAULT ('FIN-102'),
    CONSTRAINT [PK_SwMarkdownAuthority] PRIMARY KEY CLUSTERED ([MarkdownAuthorityID])
)
GO
