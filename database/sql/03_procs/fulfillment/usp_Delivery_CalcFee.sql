/* =============================================================================
   Procedure: dbo.usp_Delivery_CalcFee
   Author:    Priscilla Nance
   Created:   2018-09-04
   Purpose:   Delivery fee for a stop. Same table as fn_Delivery_ZoneFee plus the
              tier waiver (T1/T2 free within zone A/B, LOG-111 §6.3).
   Change log:
     2018-09-04  PN   Initial version
     2024-02-05  WH   Tier waiver
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Delivery_CalcFee', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Delivery_CalcFee
GO
CREATE PROCEDURE dbo.usp_Delivery_CalcFee
    @deliveryStopID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @accountID CHAR(32), @tier TINYINT, @zone VARCHAR(10), @boom BIT, @fee DECIMAL(19,2), @locationID CHAR(32)
    SELECT @orderID = ds.orderID, @boom = ds.BoomRequired, @zone = REPLACE(ds.FeeCode, 'Z', '') FROM dbo.SwDeliveryStop ds WHERE ds.DeliveryStopID = @deliveryStopID
    SELECT @accountID = accountID, @locationID = locationID FROM dbo.SwOrder WHERE orderID = @orderID
    SET @tier = dbo.fn_Account_Tier(@accountID)
    SET @fee = dbo.fn_Delivery_ZoneFee(@zone, CASE WHEN @boom = 1 THEN 'BOOM' ELSE 'FLATBED' END, @boom)
    IF @tier <= 2 AND @zone IN ('A','B') SET @fee = CASE WHEN @boom = 1 THEN 95.00 ELSE 0 END
    UPDATE dbo.SwDeliveryStop SET DeliveryFee = @fee WHERE DeliveryStopID = @deliveryStopID
    UPDATE f SET f.fulfillmentCharge = @fee, f.manualFulfillmentChargeFlag = 1 FROM dbo.SwOrderFulfillment f WHERE f.orderID = @orderID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
