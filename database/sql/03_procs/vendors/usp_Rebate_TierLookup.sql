/* =============================================================================
   Procedure: dbo.usp_Rebate_TierLookup
   Author:    Wade Hollister
   Created:   2019-01-07
   Purpose:   Rebate % for a program at a YTD basis amount (highest tier reached).
              Growth tiers compare against prior year basis which we don't store,
              so Growth = 1 rows are ignored.
   Change log:
     2019-01-07  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rebate_TierLookup', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rebate_TierLookup
GO
CREATE PROCEDURE dbo.usp_Rebate_TierLookup
    @rebateID INT,
    @ytdBasis MONEY,
    @pct FLOAT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP 1 @pct = RebatePct FROM dbo.tblRebateTier WHERE RebateID = @rebateID AND ISNULL(Growth, 0) = 0 AND @ytdBasis >= TierFrom ORDER BY TierFrom DESC
    IF @pct IS NULL SET @pct = 0
END
GO
