/* =============================================================================
   Procedure: dbo.usp_Fulfillment_UpdateMethod
   Author:    Wade Hollister
   Created:   2014-06-12
   Purpose:   Switch a fulfillment's method (e.g. ship -> pickup at store 07).
   Change log:
     2014-06-12  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Fulfillment_UpdateMethod', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Fulfillment_UpdateMethod
GO
CREATE PROCEDURE dbo.usp_Fulfillment_UpdateMethod
    @orderFulfillmentID CHAR(32),
    @fulfillmentMethodID CHAR(32),
    @locationID CHAR(32) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32), @newID CHAR(32)
    SELECT @orderID = orderID FROM dbo.SwOrderFulfillment WHERE orderFulfillmentID = @orderFulfillmentID
    EXEC dbo.usp_Fulfillment_Create @orderID = @orderID, @fulfillmentMethodID = @fulfillmentMethodID, @locationID = @locationID, @orderFulfillmentID = @newID OUTPUT
    UPDATE dbo.SwOrderItem SET orderFulfillmentID = @newID WHERE orderFulfillmentID = @orderFulfillmentID
    DELETE dbo.SwPromotionApplied WHERE orderFulfillmentID = @orderFulfillmentID
    DELETE dbo.SwOrderFulfillment WHERE orderFulfillmentID = @orderFulfillmentID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
