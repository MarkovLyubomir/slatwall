/* =============================================================================
   Procedure: dbo.usp_POS_ImportTicket
   Author:    Wade Hollister
   Created:   2015-04-20
   Purpose:   Counter ticket import from the store POS (BisTrack counter screen
              writes a pipe-delimited file; this parses one ticket). Third
              order-capture path.
   CUST-ID:   CUST-0067 (price/order path)
   Change log:
     2015-04-20  WH   Initial version
     2016-02-01  WH   Pro account lookup on BT customer number
   ============================================================================= */
IF OBJECT_ID('dbo.usp_POS_ImportTicket', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_POS_ImportTicket
GO
CREATE PROCEDURE dbo.usp_POS_ImportTicket
    @ticketHeader VARCHAR(1000),     -- store|ticket|date|custno|jobno|cashier|total
    @ticketLines  VARCHAR(MAX),      -- itemno^qty^price;itemno^qty^price;...
    @orderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @store TINYINT, @ticket VARCHAR(20), @custNo VARCHAR(20), @jobNo VARCHAR(20), @cashier VARCHAR(50), @accountID CHAR(32),
            @line VARCHAR(255), @itemNo VARCHAR(30), @qty INT, @price DECIMAL(19,2), @skuID CHAR(32), @orderNumber VARCHAR(255),
            @locationID CHAR(32), @fID CHAR(32), @fmID CHAR(32), @opID CHAR(32), @jobAccountID INT, @attrID CHAR(32), @payType VARCHAR(50)

    SELECT @store = CAST(val AS TINYINT) FROM dbo.fn_SplitString(@ticketHeader, '|') WHERE pos = 1
    SELECT @ticket = val FROM dbo.fn_SplitString(@ticketHeader, '|') WHERE pos = 2
    SELECT @custNo = val FROM dbo.fn_SplitString(@ticketHeader, '|') WHERE pos = 4
    SELECT @jobNo = val FROM dbo.fn_SplitString(@ticketHeader, '|') WHERE pos = 5
    SELECT @cashier = val FROM dbo.fn_SplitString(@ticketHeader, '|') WHERE pos = 6

    SELECT @locationID = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @store
    SELECT TOP 1 @accountID = accountID FROM dbo.SwProAccount WHERE BTCustomerNo = @custNo
    IF @accountID IS NULL SELECT TOP 1 @accountID = accountID FROM dbo.SwAccount WHERE remoteCustomerID = @custNo
    IF @accountID IS NULL SELECT TOP 1 @accountID = accountID FROM dbo.SwAccount WHERE lastName = 'CASH SALE'   -- walk-in
    IF @jobNo IS NOT NULL AND @jobNo <> ''
        SELECT TOP 1 @jobAccountID = JobAccountID FROM dbo.SwJobAccount WHERE JobNumber = @jobNo

    EXEC dbo.usp_Order_Create @accountID = @accountID, @orderOrigin = 'pos', @orderID = @orderID OUTPUT
    UPDATE dbo.SwOrder SET locationID = @locationID, remoteID = 'TKT' + @ticket WHERE orderID = @orderID

    DECLARE c CURSOR LOCAL FOR SELECT val FROM dbo.fn_SplitString(@ticketLines, ';')
    OPEN c
    FETCH NEXT FROM c INTO @line
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @itemNo = PARSENAME(REPLACE(@line, '^', '.'), 3)
        SET @qty = CAST(PARSENAME(REPLACE(@line, '^', '.'), 2) AS INT)
        SET @price = CAST(PARSENAME(REPLACE(@line, '^', '.'), 1) AS DECIMAL(19,2))   -- breaks when price has a decimal point (!), see ticket 4471
        SELECT @skuID = skuID FROM dbo.SwSku WHERE skuCode = @itemNo
        IF @skuID IS NOT NULL
            EXEC dbo.usp_Order_AddOrderItem @orderID = @orderID, @skuID = @skuID, @quantity = @qty, @priceOverride = @price
        FETCH NEXT FROM c INTO @line
    END
    CLOSE c DEALLOCATE c

    IF @jobAccountID IS NOT NULL
    BEGIN
        SELECT TOP 1 @attrID = attributeID FROM dbo.SwAttribute WHERE attributeCode = 'jobAccountID'
        INSERT dbo.SwAttributeValue (attributeValueID, attributeValue, attributeID, orderID, createdDateTime) VALUES (dbo.fn_NewID32(), CAST(@jobAccountID AS VARCHAR(20)), @attrID, @orderID, GETDATE())
    END

    SELECT TOP 1 @fmID = fulfillmentMethodID FROM dbo.SwFulfillmentMethod WHERE fulfillmentMethodType = 'pickup' AND activeFlag = 1
    EXEC dbo.usp_Fulfillment_Create @orderID = @orderID, @fulfillmentMethodID = @fmID, @locationID = @locationID, @orderFulfillmentID = @fID OUTPUT
    SET @payType = CASE WHEN @jobAccountID IS NOT NULL OR @custNo <> '' THEN 'termPayment' ELSE 'cash' END
    EXEC dbo.usp_Order_AddOrderPayment @orderID = @orderID, @paymentMethodType = @payType, @orderPaymentID = @opID OUTPUT

    SET @orderNumber = 'S' + RIGHT('0' + CAST(@store AS VARCHAR(2)), 2) + '-' + @ticket
    EXEC dbo.usp_Order_PlaceOrder @orderID = @orderID, @source = 'pos', @skipPayment = 1, @orderNumber = @orderNumber OUTPUT
END
GO
