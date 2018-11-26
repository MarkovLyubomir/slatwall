/* =============================================================================
   Procedure: dbo.usp_OrderPayment_CreateTransaction
   Author:    Wade Hollister
   Created:   2014-07-01
   Purpose:   Record a payment transaction against an order payment. The actual
              gateway call happens in the app (CF) - this just logs the result.
   Change log:
     2014-07-01  WH   Initial version
     2018-11-26  PN   Adyen fields (providerTransactionID, avsCode)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_OrderPayment_CreateTransaction', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_OrderPayment_CreateTransaction
GO
CREATE PROCEDURE dbo.usp_OrderPayment_CreateTransaction
    @orderPaymentID CHAR(32),
    @transactionType VARCHAR(255),       -- authorize, authorizeAndCharge, chargePreAuthorization, credit
    @amount DECIMAL(19,2),
    @successFlag BIT,
    @providerTransactionID VARCHAR(255) = NULL,
    @authorizationCode VARCHAR(255) = NULL,
    @avsCode VARCHAR(255) = NULL,
    @message VARCHAR(4000) = NULL
AS
BEGIN
    SET NOCOUNT ON
    INSERT dbo.SwPaymentTransaction (paymentTransactionID, transactionType, transactionSuccessFlag, providerTransactionID, transactionDateTime, authorizationCode,
                                     amountAuthorized, amountReceived, amountCredited, currencyCode, avsCode, message, createdDateTime, orderPaymentID)
    VALUES (dbo.fn_NewID32(), @transactionType, @successFlag, @providerTransactionID, GETDATE(), @authorizationCode,
            CASE WHEN @transactionType IN ('authorize','authorizeAndCharge') AND @successFlag = 1 THEN @amount ELSE 0 END,
            CASE WHEN @transactionType IN ('authorizeAndCharge','chargePreAuthorization') AND @successFlag = 1 THEN @amount ELSE 0 END,
            CASE WHEN @transactionType = 'credit' AND @successFlag = 1 THEN @amount ELSE 0 END,
            'USD', @avsCode, @message, GETDATE(), @orderPaymentID)
END
GO
