/* =============================================================================
   Procedure: dbo.usp_Pick_HandlePartial
   Author:    Priscilla Nance
   Created:   2021-11-15
   Purpose:   Short pick: try a DC transfer (creates a SwStockAdjustment), else
              leave the balance on the order and notify the customer.
   Change log:
     2021-11-15  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pick_HandlePartial', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pick_HandlePartial
GO
CREATE PROCEDURE dbo.usp_Pick_HandlePartial
    @pickTaskID INT,
    @orderItemID CHAR(32),
    @shortQty INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @skuID CHAR(32), @storeLoc CHAR(32), @dcLoc CHAR(32), @dcStock CHAR(32), @saID CHAR(32), @orderID CHAR(32), @email VARCHAR(255)
    SELECT @skuID = oi.skuID, @orderID = oi.orderID, @storeLoc = f.locationID, @email = f.emailAddress
    FROM dbo.SwOrderItem oi JOIN dbo.SwOrderFulfillment f ON f.orderFulfillmentID = oi.orderFulfillmentID WHERE oi.orderItemID = @orderItemID
    SELECT TOP 1 @dcLoc = locationID FROM dbo.SwDistributionCenter WHERE PrimaryFlag = 1
    SELECT @dcStock = stockID FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @dcLoc
    IF @dcStock IS NOT NULL AND dbo.fn_Stock_QATS(@dcStock) >= @shortQty
    BEGIN
        EXEC dbo.usp_StockAdjustment_Create @fromLocationID = @dcLoc, @toLocationID = @storeLoc, @adjustmentType = 'satLocationTransfer', @stockAdjustmentID = @saID OUTPUT
        EXEC dbo.usp_StockAdjustment_AddItems @stockAdjustmentID = @saID, @skuID = @skuID, @quantity = @shortQty
        UPDATE dbo.SwPickTask SET PickStatus = 'AWAITING_XFER' WHERE PickTaskID = @pickTaskID
    END
    ELSE
    BEGIN
        EXEC dbo.usp_Email_AddToQueue @emailTo = @email, @templateCode = 'BOPIS_PARTIAL', @relatedObject = 'Order', @relatedObjectID = @orderID
    END
END
GO
