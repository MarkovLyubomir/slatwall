/* =============================================================================
   Procedure: dbo.usp_Quote_Create
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Create a contractor quote header (O5 / SAL-205).
   Change log:
     2016-03-14  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Quote_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Quote_Create
GO
CREATE PROCEDURE dbo.usp_Quote_Create
    @accountID CHAR(32),
    @jobAccountID INT = NULL,
    @storeNumber TINYINT,
    @estimatorUser VARCHAR(50),
    @takeoffFileRef VARCHAR(200) = NULL,
    @quoteID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @tier TINYINT = dbo.fn_Account_Tier(@accountID), @days INT, @no VARCHAR(20)
    SET @days = CASE WHEN @tier <= 2 THEN 30 WHEN @tier = 3 THEN 21 ELSE 14 END
    SELECT @no = 'Q' + RIGHT('0' + CAST(@storeNumber AS VARCHAR(2)), 2) + '-' + CAST(ISNULL(MAX(QuoteID), 0) + 1 AS VARCHAR(10)) FROM dbo.SwQuote   -- race condition, known
    INSERT dbo.SwQuote (QuoteNumber, accountID, JobAccountID, StoreNumber, EstimatorUser, ValidUntil, QuoteStatus, TakeoffFileRef)
    VALUES (@no, @accountID, @jobAccountID, @storeNumber, @estimatorUser, DATEADD(DAY, @days, CAST(GETDATE() AS DATE)), 'DRAFT', @takeoffFileRef)
    SET @quoteID = SCOPE_IDENTITY()
END
GO
