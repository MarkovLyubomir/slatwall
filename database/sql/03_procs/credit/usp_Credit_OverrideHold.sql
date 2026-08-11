/* =============================================================================
   Procedure: dbo.usp_Credit_OverrideHold
   Author:    Wade Hollister
   Created:   2017-01-23
   Purpose:   Counter override: let ONE order through while the account stays on
              hold ("the truck is loaded"). Added at the request of store 03.
   NOTE:      No authority check. @justificationCode was added Aug 2026 but is
              only validated for length. Store 11 used this 212 times in Q1
              FY2026 (AUD-210 finding 3).
   Change log:
     2017-01-23  WH   Initial version
     2026-08-11  WH   @justificationCode (Appendix E) - required, not validated
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_OverrideHold', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_OverrideHold
GO
CREATE PROCEDURE dbo.usp_Credit_OverrideHold
    @orderID CHAR(32),
    @byUser VARCHAR(50),
    @storeNumber TINYINT,
    @justificationCode VARCHAR(6) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @proAccountID INT
    IF @justificationCode IS NULL OR LEN(@justificationCode) < 3
    BEGIN
        RAISERROR('Justification code required', 16, 1)
        RETURN
    END
    SELECT @proAccountID = pa.ProAccountID FROM dbo.SwOrder o JOIN dbo.SwProAccount pa ON pa.accountID = o.accountID WHERE o.orderID = @orderID AND pa.ActiveFlag = 1
    INSERT dbo.SwCreditHold (ProAccountID, HoldReason, HoldBy, ExposureAtHold, ReleasedDate, ReleasedBy, OverrideFlag, OverrideJustificationCode, OverrideStore, Notes)
    VALUES (@proAccountID, 'OVERRIDE', @byUser, dbo.fn_Credit_Exposure(@proAccountID), GETDATE(), @byUser, 1, @justificationCode, @storeNumber, 'Order ' + @orderID)
    EXEC dbo.usp_Order_TakeOffHold @orderID = @orderID, @byUser = @byUser
END
GO
