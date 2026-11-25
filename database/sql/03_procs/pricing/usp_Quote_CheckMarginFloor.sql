/* =============================================================================
   Procedure: dbo.usp_Quote_CheckMarginFloor
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Compute quote margin and set the approval level required.
              Thresholds are the FIN-102 authority ladder, hard-coded here
              (SwMarkdownAuthority exists but nothing reads it).
   Change log:
     2016-03-14  WH   Initial version
     2022-01-31  WH   Thresholds updated to FIN-102 v3.0
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_CheckMarginFloor', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_CheckMarginFloor
GO
CREATE PROCEDURE dbo.usp_Quote_CheckMarginFloor
    @quoteID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @sub DECIMAL(19,2), @cost DECIMAL(19,2), @margin DECIMAL(5,2), @level TINYINT
    SELECT @sub = SUM(Qty * ISNULL(UnitPrice, 0)), @cost = SUM(Qty * ISNULL(UnitCost, 0)) FROM dbo.SwQuoteLine WHERE QuoteID = @quoteID
    SET @margin = CASE WHEN ISNULL(@sub, 0) > 0 THEN ROUND((@sub - @cost) / @sub * 100, 2) ELSE 0 END
    SET @level = CASE
        WHEN @margin >= 22.0 THEN 0          -- estimator
        WHEN @margin >= 18.0 THEN 1          -- pro desk lead
        WHEN @margin >= 14.0 THEN 2          -- store manager
        WHEN @margin >= 10.0 THEN 3          -- regional director
        ELSE 4 END                           -- VP Pro Sales + CFO
    UPDATE dbo.SwQuote SET SubTotal = @sub, MarginPct = @margin, MarginFloorPct = 10.0, ApprovalLevel = @level, UpdatedOn = GETDATE() WHERE QuoteID = @quoteID
END
GO
