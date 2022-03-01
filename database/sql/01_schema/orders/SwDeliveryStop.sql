/* =============================================================================
   Table: dbo.SwDeliveryStop
   Database: SlatwallCommerce
   Delivery stops, windows, fees and POD
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwDeliveryStop] (
    [DeliveryStopID] INT IDENTITY(1,1) NOT NULL,
    [DeliveryRouteID] INT NULL,
    [orderDeliveryID] CHAR(32) NULL,
    [orderID] CHAR(32) NOT NULL,
    [StopSeq] TINYINT NULL,
    [WindowStart] DATETIME NULL,
    [WindowEnd] DATETIME NULL,
    [PromisedDate] DATE NULL,
    [DeliveryFee] DECIMAL(19,2) NULL,
    [FeeCode] VARCHAR(10) NULL,
    [BoomRequired] BIT NULL CONSTRAINT [DF_SwDeliveryStop_BoomRequired] DEFAULT (0),
    [JobsiteContact] VARCHAR(60) NULL,
    [ArrivedOn] DATETIME NULL,
    [CompletedOn] DATETIME NULL,
    [PODSignature] VARCHAR(100) NULL,
    [PODPhotoRef] VARCHAR(200) NULL,
    [OnTimeFlag] BIT NULL,
    [ExceptionCode] VARCHAR(10) NULL,
    CONSTRAINT [PK_SwDeliveryStop] PRIMARY KEY CLUSTERED ([DeliveryStopID])
)
GO
