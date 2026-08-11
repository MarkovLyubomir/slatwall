/* =============================================================================
   Procedure: dbo.usp_Credit_ReleaseHold
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Release the active hold. Release authority (SAL-106 §5.9):
              level 1 pro desk <= $10k exposure, 2 store manager <= $50k,
              3 credit manager <= $150k, 4 director of credit, 5 CFO.
   Change log:
     2016-06-20  WH   Initial version
     2026-08-11  WH   Authority ladder enforced (was advisory)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_ReleaseHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_ReleaseHold
GO
CREATE PROCEDURE dbo.usp_Credit_ReleaseHold
    @proAccountID INT,
    @byUser VARCHAR(50),
    @authorityLevel TINYINT,
    @notes VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @exposure DECIMAL(19,2) = dbo.fn_Credit_Exposure(@proAccountID), @required TINYINT, @holdID INT, @expInt INT
    SET @expInt = CAST(@exposure AS INT)
    SET @required = CASE WHEN @exposure <= 10000 THEN 1 WHEN @exposure <= 50000 THEN 2 WHEN @exposure <= 150000 THEN 3 WHEN @exposure <= 500000 THEN 4 ELSE 5 END
    IF @authorityLevel < @required
    BEGIN
        RAISERROR('Release requires authority level %d (exposure $%d)', 16, 1, @required, @expInt)
        RETURN
    END
    SELECT TOP 1 @holdID = CreditHoldID FROM dbo.SwCreditHold WHERE ProAccountID = @proAccountID AND ReleasedDate IS NULL ORDER BY HoldDate DESC
    UPDATE dbo.SwCreditHold SET ReleasedDate = GETDATE(), ReleasedBy = @byUser, ReleaseAuthorityLevel = @authorityLevel, Notes = ISNULL(Notes + ' | ', '') + ISNULL(@notes, '') WHERE CreditHoldID = @holdID
    -- orders stay on hold; the counter takes them off one by one
END
GO
