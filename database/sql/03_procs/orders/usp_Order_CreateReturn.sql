/* =============================================================================
   Procedure: dbo.usp_Order_CreateReturn
   Author:    Wade Hollister
   Created:   2014-11-18
   Purpose:   Create a return order referencing the original. Enforces the
              non-returnable rules from CUS-204 (cut lumber, special order).
   Change log:
     2014-11-18  WH   Initial version
     2020-07-06  PN   Non-returnable + restocking fee rules (CUS-204 v3.0)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_CreateReturn', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_CreateReturn
GO
CREATE PROCEDURE dbo.usp_Order_CreateReturn
    @orderID CHAR(32),
    @orderItemIDs VARCHAR(MAX),      -- comma separated
    @quantities VARCHAR(MAX),        -- comma separated, same order
    @returnLocationID CHAR(32),
    @reasonCode VARCHAR(10) = NULL,
    @returnOrderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @accountID CHAR(32), @orderReturnID CHAR(32), @restockPct DECIMAL(5,2), @i INT = 1, @n INT, @oiID CHAR(32), @qty INT,
            @skuID CHAR(32), @price DECIMAL(19,2), @cut BIT, @special BIT, @rmaNo VARCHAR(20)

    SELECT @accountID = accountID FROM dbo.SwOrder WHERE orderID = @orderID
    SET @returnOrderID = dbo.fn_NewID32()
    SET @orderReturnID = dbo.fn_NewID32()
    SET @restockPct = TRY_CAST(dbo.fn_SettingValue('returnRestockingFeePct') AS DECIMAL(5,2))
    IF @restockPct IS NULL SET @restockPct = 15.00

    INSERT dbo.SwOrder (orderID, currencyCode, accountID, locationID, orderTypeID, orderStatusTypeID, referencedOrderID, referencedOrderType, calculatedTotal, createdDateTime, modifiedDateTime)
    VALUES (@returnOrderID, 'USD', @accountID, @returnLocationID, dbo.fn_GetTypeID('orderType','otReturnOrder'), dbo.fn_GetTypeID('orderStatusType','ostNew'), @orderID, 'return', 0, GETDATE(), GETDATE())
    INSERT dbo.SwOrderReturn (orderReturnID, fulfillmentRefundAmount, currencyCode, orderID, returnLocationID, createdDateTime, modifiedDateTime)
    VALUES (@orderReturnID, 0, 'USD', @returnOrderID, @returnLocationID, GETDATE(), GETDATE())

    SELECT @n = COUNT(*) FROM dbo.fn_SplitString(@orderItemIDs, ',')
    WHILE @i <= @n
    BEGIN
        SELECT @oiID = val FROM dbo.fn_SplitString(@orderItemIDs, ',') WHERE pos = @i
        SELECT @qty = CAST(val AS INT) FROM dbo.fn_SplitString(@quantities, ',') WHERE pos = @i
        SELECT @skuID = skuID, @price = price FROM dbo.SwOrderItem WHERE orderItemID = @oiID

        SELECT @cut = MAX(CASE WHEN a.attributeCode = 'cutToLength' AND av.attributeValue IN ('1','true') THEN 1 ELSE 0 END),
               @special = MAX(CASE WHEN a.attributeCode = 'specialOrder' AND av.attributeValue IN ('1','true') THEN 1 ELSE 0 END)
        FROM dbo.SwAttributeValue av JOIN dbo.SwAttribute a ON a.attributeID = av.attributeID WHERE av.orderItemID = @oiID
        IF ISNULL(@cut, 0) = 1 OR ISNULL(@special, 0) = 1
        BEGIN
            RAISERROR('Line %s is non-returnable (cut or special order)', 16, 1, @oiID)
            RETURN
        END

        INSERT dbo.SwOrderItem (orderItemID, price, skuPrice, currencyCode, quantity, orderItemTypeID, orderItemStatusTypeID, skuID, orderID, orderReturnID, referencedOrderItemID, createdDateTime, modifiedDateTime)
        VALUES (dbo.fn_NewID32(), @price * (1 - @restockPct / 100.0), @price, 'USD', @qty, dbo.fn_GetTypeID('orderItemType','oitReturn'),
                dbo.fn_GetTypeID('orderItemStatusType','oistNew'), @skuID, @returnOrderID, @orderReturnID, @oiID, GETDATE(), GETDATE())
        SET @i = @i + 1
    END

    SET @rmaNo = 'RMA' + CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4)
    INSERT dbo.SwRMA (RMANumber, orderID, orderReturnID, RMAType, ReasonCode, RestockingFeePct, Status)
    VALUES (@rmaNo, @orderID, @orderReturnID, 'RETURN', @reasonCode, @restockPct, 'REQUESTED')
END
GO
