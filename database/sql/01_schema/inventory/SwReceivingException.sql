/* =============================================================================
   Table: dbo.SwReceivingException
   Database: SlatwallCommerce
   Over/short/damaged coding and chargebacks (O3)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwReceivingException] (
    [ReceivingExceptionID] INT IDENTITY(1,1) NOT NULL,
    [stockReceiverItemID] CHAR(32) NULL,
    [ASNLineID] INT NULL,
    [ExceptionCode] CHAR(3) NOT NULL,
    [ExpectedQty] DECIMAL(12,3) NULL,
    [ReceivedQty] DECIMAL(12,3) NULL,
    [DamagedQty] DECIMAL(12,3) NULL,
    [ReasonText] VARCHAR(200) NULL,
    [ChargebackFlag] BIT NULL CONSTRAINT [DF_SwReceivingException_ChargebackFlag] DEFAULT (0),
    [ChargebackAmt] DECIMAL(19,2) NULL,
    [VendorNotifiedOn] DATETIME NULL,
    [RaisedBy] VARCHAR(50) NULL,
    [RaisedOn] DATETIME NULL CONSTRAINT [DF_SwReceivingException_RaisedOn] DEFAULT (GETDATE()),
    CONSTRAINT [PK_SwReceivingException] PRIMARY KEY CLUSTERED ([ReceivingExceptionID])
)
GO
