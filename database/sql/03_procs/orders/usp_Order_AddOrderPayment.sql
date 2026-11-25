/* =============================================================================
   Procedure: dbo.usp_Order_AddOrderPayment
   Author:    Wade Hollister
   Created:   2014-07-01
   Purpose:   Add a payment (card, terms, gift card, cash) to an order.
   Change log:
     2014-07-01  WH   Initial version
     2016-02-01  WH   Terms payments resolve the payment term from the pro account
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_AddOrderPayment', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_AddOrderPayment
GO
CREATE PROCEDURE dbo.usp_Order_AddOrderPayment
    @orderID CHAR(32),
    @paymentMethodType VARCHAR(50),     -- creditCard, termPayment, giftCard, cash, external
    @amount DECIMAL(19,2) = NULL,
    @accountPaymentMethodID CHAR(32) = NULL,
    @orderPaymentID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @paymentMethodID CHAR(32), @paymentTermID CHAR(32), @accountID CHAR(32), @termsCode VARCHAR(10)
    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @orderID
    SELECT TOP 1 @paymentMethodID = paymentMethodID FROM dbo.SwPaymentMethod WHERE paymentMethodType = @paymentMethodType AND activeFlag = 1
    IF @paymentMethodType = 'termPayment'
    BEGIN
        SELECT TOP 1 @termsCode = cl.TermsCode FROM dbo.SwCreditLimit cl JOIN dbo.SwProAccount pa ON pa.ProAccountID = cl.ProAccountID
        WHERE pa.accountID = @accountID AND cl.EndDate IS NULL ORDER BY cl.EffectiveDate DESC
        SELECT TOP 1 @paymentTermID = paymentTermID FROM dbo.SwPaymentTerm WHERE paymentTermName = ISNULL(@termsCode, 'N30')
        IF @paymentTermID IS NULL SELECT TOP 1 @paymentTermID = paymentTermID FROM dbo.SwPaymentTerm WHERE activeFlag = 1 ORDER BY sortOrder
    END
    SET @orderPaymentID = dbo.fn_NewID32()
    INSERT dbo.SwOrderPayment (orderPaymentID, amount, currencyCode, orderID, orderPaymentTypeID, orderPaymentStatusTypeID, paymentMethodID, paymentTermID, accountPaymentMethodID, termPaymentAccountID, createdDateTime, modifiedDateTime)
    VALUES (@orderPaymentID, @amount, 'USD', @orderID, dbo.fn_GetTypeID('orderPaymentType','optCharge'), dbo.fn_GetTypeID('orderPaymentStatusType','opstActive'),
            @paymentMethodID, @paymentTermID, @accountPaymentMethodID, CASE WHEN @paymentTermID IS NOT NULL THEN @accountID END, GETDATE(), GETDATE())
END
GO
