/* =============================================================================
   Table: dbo.SwImage
   Database: SlatwallCommerce
   Slatwall base entity: Image
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwImage] (
    [imageID] CHAR(32) NOT NULL,
    [imageName] VARCHAR(255) NULL,
    [imageDescription] VARCHAR(4000) NULL,
    [imageFile] VARCHAR(255) NULL,
    [directory] VARCHAR(255) NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [imageTypeID] CHAR(32) NULL,
    [productID] CHAR(32) NULL,
    [promotionID] CHAR(32) NULL,
    [optionID] CHAR(32) NULL,
    CONSTRAINT [PK_SwImage] PRIMARY KEY CLUSTERED ([imageID])
)
GO
