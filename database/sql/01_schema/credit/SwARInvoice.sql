/* =============================================================================
   Table: dbo.SwARInvoice
   Database: SlatwallCommerce
   AR invoice mirror for terms orders (Billtrust feed)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwARInvoice] (
    [ARInvoiceID] INT IDENTITY(1,1) NOT NULL,
    [InvoiceNo] VARCHAR(20) NOT NULL,
    [ProAccountID] INT NOT NULL,
    [JobAccountID] INT NULL,
    [orderID] CHAR(32) NULL,
    [InvoiceDate] DATE NOT NULL,
    [DueDate] DATE NOT NULL,
    [InvoiceAmount] DECIMAL(19,2) NOT NULL,
    [PaidAmount] DECIMAL(19,2) NULL CONSTRAINT [DF_SwARInvoice_PaidAmount] DEFAULT (0),
    [DisputedAmount] DECIMAL(19,2) NULL CONSTRAINT [DF_SwARInvoice_DisputedAmount] DEFAULT (0),
    [Status] VARCHAR(10) NOT NULL CONSTRAINT [DF_SwARInvoice_Status] DEFAULT ('OPEN'),
    [BilltrustExportedOn] DATETIME NULL,
    [BTInvoiceNo] VARCHAR(20) NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwARInvoice_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwARInvoice_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwARInvoice] PRIMARY KEY CLUSTERED ([ARInvoiceID])
)
GO

CREATE NONCLUSTERED INDEX [IX_SwARInvoice_ProAccountID] ON [dbo].[SwARInvoice] ([ProAccountID])
GO

CREATE NONCLUSTERED INDEX [IX_SwARInvoice_Status] ON [dbo].[SwARInvoice] ([Status])
GO
