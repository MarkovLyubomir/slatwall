/* =============================================================================
   Procedure: dbo.usp_OrderReturn_Receive
   Author:    Wade Hollister
   Created:   2014-11-18
   Purpose:   Receive returned goods into stock (SwStockReceiver / SwInventory)
              and credit the account.
   Change log:
     2014-11-18  WH   Initial version
     2020-07-06  PN   Damaged returns go to QNC (quantity not countable) instead of QOH
   ============================================================================= */
IF OBJECT_ID('dbo.usp_OrderReturn_Receive', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_OrderReturn_Receive
GO
CREATE PROCEDURE dbo.usp_OrderReturn_Receive
    @orderReturnID CHAR(32),
    @damagedFlag BIT = 0,
    @receivedBy VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @returnOrderID CHAR(32), @locationID CHAR(32), @receiverID CHAR(32), @oiID CHAR(32), @skuID CHAR(32), @qty INT, @stockID CHAR(32), @sriID CHAR(32)
    SELECT @returnOrderID = orderID, @locationID = returnLocationID FROM dbo.SwOrderReturn WHERE orderReturnID = @orderReturnID

    SET @receiverID = dbo.fn_NewID32()
    INSERT dbo.SwStockReceiver (stockReceiverID, receiverType, orderID, createdDateTime, createdByAccountID) VALUES (@receiverID, 'order', @returnOrderID, GETDATE(), @receivedBy)

    DECLARE c CURSOR LOCAL FOR SELECT orderItemID, skuID, quantity FROM dbo.SwOrderItem WHERE orderReturnID = @orderReturnID
    OPEN c
    FETCH NEXT FROM c INTO @oiID, @skuID, @qty
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @stockID = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @locationID
        IF @stockID IS NULL
        BEGIN
            SET @stockID = dbo.fn_NewID32()
            INSERT dbo.SwStock (stockID, skuID, locationID, calculatedQOH, calculatedQATS, calculatedQNC, createdDateTime, modifiedDateTime) VALUES (@stockID, @skuID, @locationID, 0, 0, 0, GETDATE(), GETDATE())
        END
        SET @sriID = dbo.fn_NewID32()
        INSERT dbo.SwStockReceiverItem (stockReceiverItemID, quantity, currencyCode, createdDateTime, stockID, stockReceiverID, orderItemID)
        VALUES (@sriID, @qty, 'USD', GETDATE(), @stockID, @receiverID, @oiID)
        IF @damagedFlag = 0
            INSERT dbo.SwInventory (inventoryID, quantityIn, quantityOut, createdDateTime, stockID, stockReceiverItemID) VALUES (dbo.fn_NewID32(), @qty, 0, GETDATE(), @stockID, @sriID)
        ELSE
            UPDATE dbo.SwStock SET calculatedQNC = ISNULL(calculatedQNC, 0) + @qty WHERE stockID = @stockID   -- not in the ledger, only the cache
        UPDATE dbo.SwOrderItem SET orderItemStatusTypeID = dbo.fn_GetTypeID('orderItemStatusType','oistFulfilled') WHERE orderItemID = @oiID
        FETCH NEXT FROM c INTO @oiID, @skuID, @qty
    END
    CLOSE c DEALLOCATE c

    UPDATE dbo.SwRMA SET Status = 'RECEIVED' WHERE orderReturnID = @orderReturnID
    EXEC dbo.usp_Order_UpdateOrderAmounts @returnOrderID
    UPDATE dbo.SwOrder SET orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostClosed'), orderCloseDateTime = GETDATE() WHERE orderID = @returnOrderID
END
GO
