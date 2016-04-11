/* =============================================================================
   Procedure: dbo.usp_VendorOrder_Receive
   Author:    Wade Hollister
   Created:   2014-09-15
   Purpose:   Receive a whole PO (all lines at ordered qty) - the "receive all"
              button. Creates a receiver, receiver items and ledger rows.
   Change log:
     2014-09-15  WH   Initial version
     2016-04-11  WH   Close PO when fully received
   ============================================================================= */
IF OBJECT_ID('dbo.usp_VendorOrder_Receive', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_VendorOrder_Receive
GO
CREATE PROCEDURE dbo.usp_VendorOrder_Receive
    @vendorOrderID CHAR(32),
    @packingSlipNumber VARCHAR(255) = NULL,
    @receivedBy VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @receiverID CHAR(32), @voiID CHAR(32), @qty INT, @received INT
    SET @receiverID = dbo.fn_NewID32()
    INSERT dbo.SwStockReceiver (stockReceiverID, packingSlipNumber, receiverType, vendorOrderID, createdDateTime, createdByAccountID) VALUES (@receiverID, @packingSlipNumber, 'vendorOrder', @vendorOrderID, GETDATE(), @receivedBy)
    DECLARE c CURSOR LOCAL FOR SELECT vendorOrderItemID, quantity FROM dbo.SwVendorOrderItem WHERE vendorOrderID = @vendorOrderID
    OPEN c
    FETCH NEXT FROM c INTO @voiID, @qty
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @received = ISNULL(SUM(quantity), 0) FROM dbo.SwStockReceiverItem WHERE vendorOrderItemID = @voiID
        IF @qty - @received > 0
            EXEC dbo.usp_VendorOrder_ReceiveItem @stockReceiverID = @receiverID, @vendorOrderItemID = @voiID, @quantity = @qty - @received
        FETCH NEXT FROM c INTO @voiID, @qty
    END
    CLOSE c DEALLOCATE c
    UPDATE dbo.SwVendorOrder SET vendorOrderStatusTypeID = dbo.fn_GetTypeID('vendorOrderStatusType','vostClosed'), modifiedDateTime = GETDATE() WHERE vendorOrderID = @vendorOrderID
END
GO
