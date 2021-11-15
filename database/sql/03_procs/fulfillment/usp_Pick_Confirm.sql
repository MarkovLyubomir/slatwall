/* =============================================================================
   Procedure: dbo.usp_Pick_Confirm
   Author:    Priscilla Nance
   Created:   2019-10-08
   Purpose:   Yard/counter confirms picked quantities per line; shorts recorded.
   Change log:
     2019-10-08  PN   Initial version
     2021-11-15  PN   Partial handling moved to usp_Pick_HandlePartial
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pick_Confirm', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pick_Confirm
GO
CREATE PROCEDURE dbo.usp_Pick_Confirm
    @pickTaskID INT,
    @orderItemID CHAR(32),
    @pickedQty INT,
    @pickedBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ordered INT, @attrID CHAR(32)
    SELECT @ordered = quantity FROM dbo.SwOrderItem WHERE orderItemID = @orderItemID
    UPDATE dbo.SwPickTask SET PickStatus = 'PICKING', PickStartedOn = ISNULL(PickStartedOn, GETDATE()), AssignedTo = @pickedBy WHERE PickTaskID = @pickTaskID
    -- picked qty kept as an attribute value on the order item (no column for it)
    SELECT TOP 1 @attrID = attributeID FROM dbo.SwAttribute WHERE attributeCode = 'pickedQty'
    DELETE dbo.SwAttributeValue WHERE orderItemID = @orderItemID AND attributeID = @attrID
    INSERT dbo.SwAttributeValue (attributeValueID, attributeValue, attributeID, orderItemID, createdDateTime) VALUES (dbo.fn_NewID32(), CAST(@pickedQty AS VARCHAR(10)), @attrID, @orderItemID, GETDATE())
    IF @pickedQty < @ordered
    BEGIN
        UPDATE dbo.SwPickTask SET ShortLineCount = ISNULL(ShortLineCount, 0) + 1, PartialFlag = 1 WHERE PickTaskID = @pickTaskID
        EXEC dbo.usp_Pick_HandlePartial @pickTaskID = @pickTaskID, @orderItemID = @orderItemID, @shortQty = @ordered - @pickedQty
    END
END
GO
