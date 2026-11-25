/* =============================================================================
   Table: dbo.SwAttributeSetProductType
   Database: SlatwallCommerce
   Slatwall base entity: None
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwAttributeSetProductType] (
    [attributeSetID] CHAR(32) NOT NULL,
    [productTypeID] CHAR(32) NOT NULL,
    CONSTRAINT [PK_SwAttributeSetProductType] PRIMARY KEY CLUSTERED ([attributeSetID], [productTypeID])
)
GO
