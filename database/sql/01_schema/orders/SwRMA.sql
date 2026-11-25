/* =============================================================================
   Table: dbo.SwRMA
   Database: SlatwallCommerce
   Returns / RMA / warranty (O4)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwRMA] (
    [RMAID] INT IDENTITY(1,1) NOT NULL,
    [RMANumber] VARCHAR(20) NOT NULL,
    [orderID] CHAR(32) NOT NULL,
    [orderReturnID] CHAR(32) NULL,
    [RMAType] VARCHAR(12) NOT NULL,
    [ReasonCode] VARCHAR(10) NULL,
    [RequestedOn] DATETIME NOT NULL CONSTRAINT [DF_SwRMA_RequestedOn] DEFAULT (GETDATE()),
    [ApprovedOn] DATETIME NULL,
    [ApprovedBy] VARCHAR(50) NULL,
    [RestockingFeePct] DECIMAL(5,2) NULL,
    [RestockingFeeAmt] DECIMAL(19,2) NULL,
    [NonReturnableFlag] BIT NULL CONSTRAINT [DF_SwRMA_NonReturnableFlag] DEFAULT (0),
    [WarrantyVendorNo] VARCHAR(20) NULL,
    [FreightClaimRef] VARCHAR(40) NULL,
    [Status] VARCHAR(12) NULL CONSTRAINT [DF_SwRMA_Status] DEFAULT ('REQUESTED'),
    [ReceivedStore] TINYINT NULL,
    [CreatedOn] DATETIME NOT NULL CONSTRAINT [DF_SwRMA_CreatedOn] DEFAULT (GETDATE()),
    [CreatedBy] VARCHAR(50) NOT NULL CONSTRAINT [DF_SwRMA_CreatedBy] DEFAULT (SUSER_SNAME()),
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    CONSTRAINT [PK_SwRMA] PRIMARY KEY CLUSTERED ([RMAID])
)
GO
