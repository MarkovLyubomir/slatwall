/* =============================================================================
   Table: dbo.SwOrderReturn
   Database: SlatwallCommerce
   Slatwall base entity: OrderReturn
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderReturn] (
    [orderReturnID] CHAR(32) NOT NULL,
    [fulfillmentRefundAmount] DECIMAL(19,2) NULL,
    [currencyCode] VARCHAR(3) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [orderID] CHAR(32) NULL,
    [returnLocationID] CHAR(32) NULL,
    CONSTRAINT [PK_SwOrderReturn] PRIMARY KEY CLUSTERED ([orderReturnID])
)
GO
