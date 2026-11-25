/* =============================================================================
   Procedure: dbo.usp_Quote_Approve
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Approve/issue a quote. Approver role is a free-text parameter
              compared with a CASE - nothing checks the user actually has it.
   Change log:
     2016-03-14  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_Approve', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_Approve
GO
CREATE PROCEDURE dbo.usp_Quote_Approve
    @quoteID INT,
    @approverUser VARCHAR(50),
    @approverRole VARCHAR(20)      -- ESTIMATOR, PRODESK, STOREMGR, RD, VP
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @required TINYINT, @have TINYINT
    SELECT @required = ApprovalLevel FROM dbo.SwQuote WHERE QuoteID = @quoteID
    SET @have = CASE @approverRole WHEN 'ESTIMATOR' THEN 0 WHEN 'PRODESK' THEN 1 WHEN 'STOREMGR' THEN 2 WHEN 'RD' THEN 3 WHEN 'VP' THEN 4 ELSE 0 END
    IF @have < @required
    BEGIN
        RAISERROR('Quote requires approval level %d', 16, 1, @required)
        RETURN
    END
    UPDATE dbo.SwQuote SET QuoteStatus = 'ISSUED', ApprovedBy = @approverUser, ApprovedOn = GETDATE(), UpdatedOn = GETDATE() WHERE QuoteID = @quoteID
END
GO
