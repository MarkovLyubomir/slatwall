/* =============================================================================
   Table: dbo.tblVendorRebate
   Database: SlatwallCommerce
   LEGACY: imported from VendorRebates.accdb
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblVendorRebate] (
    [RebateID] INT IDENTITY(1,1) NOT NULL,
    [VendorNo] VARCHAR(20) NULL,
    [VendorName] VARCHAR(100) NULL,
    [ProgramYear] SMALLINT NULL,
    [ProgramDesc] VARCHAR(200) NULL,
    [RebateType] VARCHAR(20) NULL,
    [BasisAmt] MONEY NULL,
    [AccruedAmt] MONEY NULL,
    [ReceivedAmt] MONEY NULL,
    [LastAccrualDate] DATETIME NULL,
    [Notes] VARCHAR(MAX) NULL,
    [EnteredBy] VARCHAR(30) NULL,
    CONSTRAINT [PK_tblVendorRebate] PRIMARY KEY CLUSTERED ([RebateID])
)
GO
