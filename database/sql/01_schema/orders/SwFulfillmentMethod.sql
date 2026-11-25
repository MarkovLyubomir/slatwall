/* =============================================================================
   Table: dbo.SwFulfillmentMethod
   Database: SlatwallCommerce
   Slatwall base entity: FulfillmentMethod
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwFulfillmentMethod] (
    [fulfillmentMethodID] CHAR(32) NOT NULL,
    [fulfillmentMethodName] VARCHAR(255) NULL,
    [fulfillmentMethodType] VARCHAR(255) NULL,
    [activeFlag] BIT NULL,
    [sortOrder] INT NULL,
    [autoFulfillFlag] BIT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    CONSTRAINT [PK_SwFulfillmentMethod] PRIMARY KEY CLUSTERED ([fulfillmentMethodID])
)
GO
