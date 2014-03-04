/* =============================================================================
   Table: dbo.SwPaymentTerm
   Database: SlatwallCommerce
   Slatwall base entity: PaymentTerm
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPaymentTerm] (
    [paymentTermID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [paymentTermName] VARCHAR(255) NULL,
    [sortOrder] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [termID] CHAR(32) NULL,
    CONSTRAINT [PK_SwPaymentTerm] PRIMARY KEY CLUSTERED ([paymentTermID])
)
GO
