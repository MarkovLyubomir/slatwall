/* =============================================================================
   Table: dbo.SwProductBundleBuild
   Database: SlatwallCommerce
   Slatwall base entity: ProductBundleBuild
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProductBundleBuild] (
    [productBundleBuildID] CHAR(32) NOT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [productBundleSkuID] CHAR(32) NULL,
    [sessionID] CHAR(32) NULL,
    [accountID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProductBundleBuild] PRIMARY KEY CLUSTERED ([productBundleBuildID])
)
GO
