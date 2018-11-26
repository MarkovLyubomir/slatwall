/* =============================================================================
   Procedure: dbo.usp_OrderPayment_RunPlaceOrderTransaction
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Place-order payment for web orders. Calls the Adyen bridge CLR
              assembly (SlatwallPayBridge.dll) and records the transaction.
   NOTE:      The CLR assembly is UNSAFE and signed with a key that lives on
              Wade's workstation.
   Change log:
     2018-11-26  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_OrderPayment_RunPlaceOrderTransaction', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_OrderPayment_RunPlaceOrderTransaction
GO
CREATE PROCEDURE dbo.usp_OrderPayment_RunPlaceOrderTransaction
    @orderID CHAR(32),
    @success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderPaymentID CHAR(32), @amount DECIMAL(19,2), @txnType VARCHAR(255), @providerRef VARCHAR(255), @auth VARCHAR(255), @msg VARCHAR(4000), @rc INT
    SET @success = 0
    SELECT TOP 1 @orderPaymentID = op.orderPaymentID, @amount = op.amount, @txnType = pm.placeOrderChargeTransactionType
    FROM dbo.SwOrderPayment op JOIN dbo.SwPaymentMethod pm ON pm.paymentMethodID = op.paymentMethodID
    WHERE op.orderID = @orderID AND op.orderPaymentStatusTypeID = dbo.fn_GetTypeID('orderPaymentStatusType','opstActive') AND op.paymentTermID IS NULL
    IF @orderPaymentID IS NULL RETURN

    IF @amount IS NULL OR @amount = 0 SELECT @amount = calculatedTotal FROM dbo.SwOrder WHERE orderID = @orderID

    -- CLR bridge: dbo.clr_AdyenAuthorize(@merchantRef, @amountMinor, @timeoutSec) returns 'OK|<psp ref>|<auth>' or 'ERR|<message>'
    DECLARE @result NVARCHAR(400)
    BEGIN TRY
        SET @result = dbo.clr_AdyenAuthorize(@orderPaymentID, CAST(@amount * 100 AS BIGINT), 20)
    END TRY
    BEGIN CATCH
        SET @result = 'ERR|' + ERROR_MESSAGE()
    END CATCH

    IF LEFT(@result, 2) = 'OK'
    BEGIN
        SET @success = 1
        SET @providerRef = PARSENAME(REPLACE(@result, '|', '.'), 2)
        SET @auth = PARSENAME(REPLACE(@result, '|', '.'), 1)
    END
    ELSE
        SET @msg = SUBSTRING(@result, 5, 4000)

    EXEC dbo.usp_OrderPayment_CreateTransaction @orderPaymentID = @orderPaymentID, @transactionType = @txnType, @amount = @amount, @successFlag = @success,
                                                @providerTransactionID = @providerRef, @authorizationCode = @auth, @message = @msg
    IF @success = 0 RAISERROR('Gateway: %s', 16, 1, @msg)
END
GO
