/* =============================================================================
   Table: dbo.SwPostalCode
   Database: SlatwallCommerce
   Slatwall base entity: PostalCode
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwPostalCode] (
    [postalCode] CHAR(32) NOT NULL,
    [city] VARCHAR(255) NULL,
    [latitude] VARCHAR(255) NULL,
    [longitude] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [countryCode] CHAR(32) NULL,
    [stateCode,countryCode] CHAR(32) NULL,
    CONSTRAINT [PK_SwPostalCode] PRIMARY KEY CLUSTERED ([postalCode])
)
GO
