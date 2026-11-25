/* =============================================================================
   Table: dbo.SwProductReview
   Database: SlatwallCommerce
   Slatwall base entity: ProductReview
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwProductReview] (
    [productReviewID] CHAR(32) NOT NULL,
    [activeFlag] BIT NULL,
    [reviewerName] VARCHAR(255) NULL,
    [review] VARCHAR(4000) NULL,
    [reviewTitle] VARCHAR(255) NULL,
    [rating] INT NULL,
    [remoteID] VARCHAR(255) NULL,
    [createdDateTime] DATETIME NULL,
    [createdByAccountID] VARCHAR(255) NULL,
    [modifiedDateTime] DATETIME NULL,
    [modifiedByAccountID] VARCHAR(255) NULL,
    [productID] CHAR(32) NULL,
    [accountID] CHAR(32) NULL,
    [skuID] CHAR(32) NULL,
    CONSTRAINT [PK_SwProductReview] PRIMARY KEY CLUSTERED ([productReviewID])
)
GO
