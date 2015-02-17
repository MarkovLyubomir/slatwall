/* =============================================================================
   Table: dbo.SwOrderStatusLog
   Database: SlatwallCommerce
   Order status audit (trigger-fed; no FK on purpose 'for performance')
   Generated for Slatwall Building Supply Co. - FICTIONAL SAMPLE (3Pillar Atlas demo)
   ============================================================================= */

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SwOrderStatusLog] (
    [OrderStatusLogID] BIGINT IDENTITY(1,1) NOT NULL,
    [orderID] CHAR(32) NOT NULL,
    [OldStatusCode] VARCHAR(20) NULL,
    [NewStatusCode] VARCHAR(20) NULL,
    [ChangedOn] DATETIME NOT NULL CONSTRAINT [DF_SwOrderStatusLog_ChangedOn] DEFAULT (GETDATE()),
    [ChangedBy] VARCHAR(50) NULL,
    [Source] VARCHAR(20) NULL,
    CONSTRAINT [PK_SwOrderStatusLog] PRIMARY KEY CLUSTERED ([OrderStatusLogID])
)
GO
