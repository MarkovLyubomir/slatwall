/* =============================================================================
   Table: dbo.SwAccountPaymentApplied
   Database: SlatwallCommerce
   Slatwall base entity: AccountPaymentApplied
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAccountPaymentApplied] (
    [accountPaymentAppliedID] CHAR(32) NOT NULL,
    [amount] DECIMAL(19,2) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [accountPaymentID] CHAR(32) NULL,
    [orderPaymentID] CHAR(32) NULL,
    [accountPaymentTypeID] CHAR(32) NULL,
    CONSTRAINT [PK_SwAccountPaymentApplied] PRIMARY KEY CLUSTERED ([accountPaymentAppliedID])
)
GO
