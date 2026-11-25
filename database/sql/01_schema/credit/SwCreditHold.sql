/* =============================================================================
   Table: dbo.SwCreditHold
   Database: SlatwallCommerce
   Credit holds, releases and overrides (T6 §5.8-5.9, O10)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwCreditHold] (
    [CreditHoldID] INT IDENTITY(1,1) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [HoldReason] VARCHAR(20) NOT NULL,
    [HoldDate] DATETIME NOT NULL CONSTRAINT [DF_SwCreditHold_HoldDate] DEFAULT (GETDATE()),
    [HoldBy] VARCHAR(50) NULL,
    [ExposureAtHold] DECIMAL(19,2) NULL,
    [ReleasedDate] DATETIME NULL,
    [ReleasedBy] VARCHAR(50) NULL,
    [ReleaseAuthorityLevel] TINYINT NULL,
    [OverrideFlag] BIT NULL CONSTRAINT [DF_SwCreditHold_OverrideFlag] DEFAULT (0),
    [OverrideJustificationCode] VARCHAR(6) NULL,
    [OverrideStore] TINYINT NULL,
    [Notes] VARCHAR(500) NULL,
    CONSTRAINT [PK_SwCreditHold] PRIMARY KEY CLUSTERED ([CreditHoldID])
)
GO
