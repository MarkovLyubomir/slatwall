/* =============================================================================
   Procedure: dbo.usp_Credit_CheckAvailable
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Can this pro account take @amount more on terms? Exposure from
              fn_Credit_Exposure vs. the active credit limit; an active hold
              always says no.
   CUST-ID:   CUST-0055 (order path)
   Change log:
     2016-06-20  WH   Initial version
     2019-04-02  WH   Job-level limits
     2024-02-05  WH   Default limit by tier when no SwCreditLimit row (T1 $250k ... T5 $5k)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_CheckAvailable', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_CheckAvailable
GO
CREATE PROCEDURE dbo.usp_Credit_CheckAvailable
    @proAccountID INT,
    @amount DECIMAL(19,2),
    @jobAccountID INT = NULL,
    @ok BIT OUTPUT,
    @exposure DECIMAL(19,2) = NULL OUTPUT,
    @creditLimit DECIMAL(19,2) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @tier TINYINT, @jobLimit DECIMAL(19,2), @jobExposure DECIMAL(19,2)
    SET @ok = 0
    SET @exposure = dbo.fn_Credit_Exposure(@proAccountID)

    SELECT TOP 1 @creditLimit = CreditLimit FROM dbo.SwCreditLimit WHERE ProAccountID = @proAccountID AND JobAccountID IS NULL AND EndDate IS NULL ORDER BY EffectiveDate DESC
    IF @creditLimit IS NULL
    BEGIN
        SELECT @tier = Tier FROM dbo.SwProAccount WHERE ProAccountID = @proAccountID
        SET @creditLimit = CASE @tier WHEN 1 THEN 250000 WHEN 2 THEN 100000 WHEN 3 THEN 50000 WHEN 4 THEN 15000 ELSE 5000 END
    END

    IF EXISTS (SELECT 1 FROM dbo.SwCreditHold WHERE ProAccountID = @proAccountID AND ReleasedDate IS NULL) RETURN

    IF @jobAccountID IS NOT NULL
    BEGIN
        SELECT TOP 1 @jobLimit = CreditLimit FROM dbo.SwCreditLimit WHERE JobAccountID = @jobAccountID AND EndDate IS NULL ORDER BY EffectiveDate DESC
        IF @jobLimit IS NOT NULL
        BEGIN
            SELECT @jobExposure = ISNULL(SUM(InvoiceAmount - PaidAmount), 0) FROM dbo.SwARInvoice WHERE JobAccountID = @jobAccountID AND Status IN ('OPEN','PASTDUE')
            IF @jobExposure + @amount > @jobLimit RETURN
        END
    END

    IF @exposure + @amount <= @creditLimit SET @ok = 1
END
GO
