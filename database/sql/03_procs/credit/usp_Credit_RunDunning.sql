/* =============================================================================
   Procedure: dbo.usp_Credit_RunDunning
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Five-stage dunning (SAL-106 §7.3): 1 reminder @ 5 days, 2 notice @ 15,
              3 call @ 30, 4 hold @ 45, 5 final demand / legal @ 75. Stage 4
              places a credit hold. Emails go to SwEmail queue.
   Change log:
     2016-06-20  WH   Initial version (3 stages)
     2025-02-10  WH   Five stages; Billtrust sends stages 1-2, we log them
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_RunDunning', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_RunDunning
GO
CREATE PROCEDURE dbo.usp_Credit_RunDunning
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    DECLARE @proAccountID INT, @oldest INT, @pastDue DECIMAL(19,2), @stage TINYINT, @lastStage TINYINT, @email VARCHAR(255)

    DECLARE c CURSOR LOCAL FOR
        SELECT ProAccountID, MAX(DATEDIFF(DAY, DueDate, @asOf)), SUM(InvoiceAmount - PaidAmount - DisputedAmount)
        FROM dbo.SwARInvoice WHERE Status = 'PASTDUE' GROUP BY ProAccountID HAVING SUM(InvoiceAmount - PaidAmount - DisputedAmount) > 100
    OPEN c
    FETCH NEXT FROM c INTO @proAccountID, @oldest, @pastDue
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @stage = CASE WHEN @oldest >= 75 THEN 5 WHEN @oldest >= 45 THEN 4 WHEN @oldest >= 30 THEN 3 WHEN @oldest >= 15 THEN 2 WHEN @oldest >= 5 THEN 1 ELSE 0 END
        SELECT @lastStage = ISNULL(MAX(Stage), 0) FROM dbo.SwDunningEvent WHERE ProAccountID = @proAccountID AND EventDate > DATEADD(DAY, -90, @asOf)
        IF @stage > @lastStage
        BEGIN
            INSERT dbo.SwDunningEvent (ProAccountID, Stage, EventDate, PastDueAmount, OldestInvoiceDays, Channel, SentBy)
            VALUES (@proAccountID, @stage, @asOf, @pastDue, @oldest, CASE WHEN @stage <= 2 THEN 'BILLTRUST' WHEN @stage = 3 THEN 'PHONE' ELSE 'LETTER' END, 'nightly')
            IF @stage >= 4 AND NOT EXISTS (SELECT 1 FROM dbo.SwCreditHold WHERE ProAccountID = @proAccountID AND ReleasedDate IS NULL)
                EXEC dbo.usp_Credit_PlaceHold @proAccountID = @proAccountID, @reason = 'PASTDUE', @byUser = 'dunning', @notes = 'Stage 4 auto-hold'
            IF @stage >= 3
            BEGIN
                SELECT TOP 1 @email = ae.emailAddress FROM dbo.SwProAccount pa JOIN dbo.SwAccount a ON a.accountID = pa.accountID JOIN dbo.SwAccountEmailAddress ae ON ae.accountEmailAddressID = a.primaryEmailAddressID WHERE pa.ProAccountID = @proAccountID
                EXEC dbo.usp_Email_AddToQueue @emailTo = @email, @templateCode = 'DUNNING_STAGE' , @relatedObject = 'ProAccount', @relatedObjectID = @proAccountID
            END
        END
        FETCH NEXT FROM c INTO @proAccountID, @oldest, @pastDue
    END
    CLOSE c DEALLOCATE c
END
GO
