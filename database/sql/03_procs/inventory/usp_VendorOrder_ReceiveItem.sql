/* =============================================================================
   Procedure: dbo.usp_VendorOrder_ReceiveItem
   Author:    Wade Hollister
   Created:   2014-09-15
   Purpose:   Receive one PO line (partial allowed) onto an existing receiver.
   Change log:
     2014-09-15  WH   Initial version
     2020-02-24  WH   Over-receipt creates a SwReceivingException (code OVR)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_VendorOrder_ReceiveItem', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_VendorOrder_ReceiveItem
GO
CREATE PROCEDURE dbo.usp_VendorOrder_ReceiveItem
    @stockReceiverID CHAR(32),
    @vendorOrderItemID CHAR(32),
    @quantity INT,
    @cost DECIMAL(19,2) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @stockID CHAR(32), @ordered INT, @received INT, @sriID CHAR(32)
    SELECT @stockID = stockID, @ordered = quantity, @cost = ISNULL(@cost, cost) FROM dbo.SwVendorOrderItem WHERE vendorOrderItemID = @vendorOrderItemID
    SELECT @received = ISNULL(SUM(quantity), 0) FROM dbo.SwStockReceiverItem WHERE vendorOrderItemID = @vendorOrderItemID
    SET @sriID = dbo.fn_NewID32()
    INSERT dbo.SwStockReceiverItem (stockReceiverItemID, quantity, cost, currencyCode, createdDateTime, stockID, stockReceiverID, vendorOrderItemID)
    VALUES (@sriID, @quantity, @cost, 'USD', GETDATE(), @stockID, @stockReceiverID, @vendorOrderItemID)
    INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, stockReceiverItemID) VALUES (dbo.fn_NewID32(), @quantity, 0, GETDATE(), @stockID, @sriID)
    IF @received + @quantity > @ordered
        INSERT dbo.SwReceivingException (stockReceiverItemID, ExceptionCode, ExpectedQty, ReceivedQty, RaisedBy) VALUES (@sriID, 'OVR', @ordered, @received + @quantity, SUSER_SNAME())
END
GO
