/* =============================================================================
   Table: dbo.SwASNLine
   Database: SlatwallCommerce
   ASN lines
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwASNLine] (
    [ASNLineID] INT IDENTITY(1,1) NOT NULL,
    [ASNID] INT NOT NULL,
    [LineNo] SMALLINT NOT NULL,
    [ItemNo] VARCHAR(30) NULL,
    [skuID] CHAR(32) NULL,
    [ShippedQty] DECIMAL(12,3) NULL,
    [UOM] VARCHAR(8) NULL,
    [LotNo] VARCHAR(30) NULL,
    CONSTRAINT [PK_SwASNLine] PRIMARY KEY CLUSTERED ([ASNLineID])
)
GO
