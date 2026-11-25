/* =============================================================================
   Table: dbo.SwOptionGroupProductType
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOptionGroupProductType] (
    [optionGroupID] CHAR(32) NOT NULL,
    [productTypeID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwOptionGroupProductType] PRIMARY KEY CLUSTERED ([optionGroupID], [productTypeID])
)
GO
