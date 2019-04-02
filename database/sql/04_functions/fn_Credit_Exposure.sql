/* =============================================================================
   Function:  dbo.fn_Credit_Exposure
   Author:    Wade Hollister
   Created:   2016-06-20
   Purpose:   Open AR + unbilled terms orders for a pro account (job accounts roll up).
   Change log:
     2016-06-20  WH   Initial version
     2019-04-02  WH   Include unbilled open orders on terms
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Credit_Exposure') IS NOT NULL DROP FUNCTION dbo.fn_Credit_Exposure
GO
CREATE FUNCTION dbo.fn_Credit_Exposure(@proAccountID INT)
RETURNS DECIMAL(19,2)
AS
BEGIN
    DECLARE @ar DECIMAL(19,2), @unbilled DECIMAL(19,2)
    SELECT @ar = ISNULL(SUM(InvoiceAmount - PaidAmount - DisputedAmount), 0)
    FROM dbo.SwARInvoice WHERE ProAccountID = @proAccountID AND Status IN ('OPEN','PASTDUE')

    SELECT @unbilled = ISNULL(SUM(o.calculatedTotal), 0)
    FROM dbo.SwOrder o
    JOIN dbo.SwProAccount pa ON pa.accountID = o.accountID
    JOIN dbo.SwOrderPayment op ON op.orderID = o.orderID AND op.paymentTermID IS NOT NULL
    WHERE pa.ProAccountID = @proAccountID
      AND o.orderStatusTypeID IN (dbo.fn_GetTypeID('orderStatusType','ostNew'), dbo.fn_GetTypeID('orderStatusType','ostProcessing'))
      AND NOT EXISTS (SELECT 1 FROM dbo.SwARInvoice i WHERE i.orderID = o.orderID)
    RETURN @ar + @unbilled
END
GO
