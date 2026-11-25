/* =============================================================================
   Procedure: dbo.usp_Receiving_RaiseChargeback
   Author:    Wade Hollister
   Created:   2022-08-15
   Purpose:   Compute the chargeback amount for a receiving exception (short at
              cost + $75 handling per LEG-110 schedule B) and queue the vendor email.
   Change log:
     2022-08-15  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Receiving_RaiseChargeback', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Receiving_RaiseChargeback
GO
CREATE PROCEDURE dbo.usp_Receiving_RaiseChargeback
    @receivingExceptionID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @cost DECIMAL(19,2), @short DECIMAL(12,3), @amt DECIMAL(19,2), @vendorEmail VARCHAR(255), @vendorID CHAR(32)
    SELECT @cost = sri.cost, @short = ISNULL(re.ExpectedQty, 0) - ISNULL(re.ReceivedQty, 0) + ISNULL(re.DamagedQty, 0), @vendorID = vo.vendorID
    FROM dbo.SwReceivingException re JOIN dbo.SwStockReceiverItem sri ON sri.stockReceiverItemID = re.stockReceiverItemID
    JOIN dbo.SwStockReceiver sr ON sr.stockReceiverID = sri.stockReceiverID JOIN dbo.SwVendorOrder vo ON vo.vendorOrderID = sr.vendorOrderID
    WHERE re.ReceivingExceptionID = @receivingExceptionID
    SET @amt = ROUND(@short * ISNULL(@cost, 0) + 75.00, 2)
    UPDATE dbo.SwReceivingException SET ChargebackFlag = 1, ChargebackAmt = @amt WHERE ReceivingExceptionID = @receivingExceptionID
    SELECT TOP 1 @vendorEmail = ve.emailAddress FROM dbo.SwVendor v JOIN dbo.SwVendorEmailAddress ve ON ve.vendorEmailAddressID = v.primaryEmailAddressID WHERE v.vendorID = @vendorID
    EXEC dbo.usp_Email_AddToQueue @emailTo = @vendorEmail, @templateCode = 'VENDOR_CHARGEBACK', @relatedObject = 'ReceivingException', @relatedObjectID = @receivingExceptionID
    UPDATE dbo.SwReceivingException SET VendorNotifiedOn = GETDATE() WHERE ReceivingExceptionID = @receivingExceptionID
END
GO
