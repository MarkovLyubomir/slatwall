/* =============================================================================
   Table: dbo.SwShrinkEvent
   Database: SlatwallCommerce
   Shrink events by store (O10)
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwShrinkEvent] (
    [ShrinkEventID] INT IDENTITY(1,1) NOT NULL,
    [StoreNumber] TINYINT NOT NULL,
    [skuID] CHAR(32) NULL,
    [EventDate] DATE NOT NULL,
    [ShrinkType] VARCHAR(12) NOT NULL,
    [Qty] DECIMAL(12,3) NULL,
    [CostValue] DECIMAL(19,2) NULL,
    [SourceRef] VARCHAR(40) NULL,
    [physicalCountID] CHAR(32) NULL,
    [OverrideUser] VARCHAR(50) NULL,
    [Notes] VARCHAR(300) NULL,
    CONSTRAINT [PK_SwShrinkEvent] PRIMARY KEY CLUSTERED ([ShrinkEventID])
)
GO
