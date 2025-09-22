/* =============================================================================
   Procedure: dbo.usp_Billtrust_ImportPayments
   Author:    Wade Hollister
   Created:   2025-02-10
   Purpose:   Apply the Billtrust cash-application file (loaded to a staging
              global temp by the SSIS package) to SwARInvoice and mirror into
              SwAccountPayment/SwAccountPaymentApplied for the Slatwall screens.
   Change log:
     2025-02-10  WH   Initial version
     2025-09-22  WH   Short-pays create a DisputedAmount instead of leaving the invoice open
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Billtrust_ImportPayments', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Billtrust_ImportPayments
GO
CREATE PROCEDURE dbo.usp_Billtrust_ImportPayments
AS
BEGIN
    SET NOCOUNT ON
    IF OBJECT_ID('tempdb..##BilltrustPayments') IS NULL
    BEGIN
        RAISERROR('Staging ##BilltrustPayments missing', 16, 1)
        RETURN
    END
    DECLARE @invoiceNo VARCHAR(20), @amt DECIMAL(19,2), @ref VARCHAR(40), @accountID CHAR(32), @apID CHAR(32), @opID CHAR(32), @open DECIMAL(19,2)
    DECLARE c CURSOR LOCAL FOR SELECT InvoiceNo, Amount, PaymentRef FROM ##BilltrustPayments
    OPEN c
    FETCH NEXT FROM c INTO @invoiceNo, @amt, @ref
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @accountID = pa.accountID, @open = i.InvoiceAmount - i.PaidAmount FROM dbo.SwARInvoice i JOIN dbo.SwProAccount pa ON pa.ProAccountID = i.ProAccountID WHERE i.InvoiceNo = @invoiceNo
        IF @accountID IS NOT NULL
        BEGIN
            UPDATE dbo.SwARInvoice SET PaidAmount = PaidAmount + @amt,
                                       DisputedAmount = CASE WHEN @amt < @open AND @open - @amt < 50 THEN @open - @amt ELSE DisputedAmount END,   -- short pay tolerance
                                       Status = CASE WHEN PaidAmount + @amt >= InvoiceAmount - 0.01 THEN 'PAID' ELSE Status END, UpdatedOn = GETDATE(), UpdatedBy = 'billtrust'
            WHERE InvoiceNo = @invoiceNo
            SET @apID = dbo.fn_NewID32()
            INSERT dbo.SwAccountPayment (accountPaymentID, currencyCode, accountID, accountPaymentTypeID, remoteID, createdDateTime, modifiedDateTime)
            VALUES (@apID, 'USD', @accountID, dbo.fn_GetTypeID('accountPaymentType','aptCharge'), @ref, GETDATE(), GETDATE())
            SELECT TOP 1 @opID = op.orderPaymentID FROM dbo.SwARInvoice i JOIN dbo.SwOrderPayment op ON op.orderID = i.orderID WHERE i.InvoiceNo = @invoiceNo AND op.paymentTermID IS NOT NULL
            INSERT dbo.SwAccountPaymentApplied (accountPaymentAppliedID, amount, accountPaymentID, orderPaymentID, createdDateTime, modifiedDateTime) VALUES (dbo.fn_NewID32(), @amt, @apID, @opID, GETDATE(), GETDATE())
        END
        FETCH NEXT FROM c INTO @invoiceNo, @amt, @ref
    END
    CLOSE c DEALLOCATE c
END
GO
