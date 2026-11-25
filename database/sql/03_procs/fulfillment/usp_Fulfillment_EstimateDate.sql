/* =============================================================================
   Procedure: dbo.usp_Fulfillment_EstimateDate
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Estimated fulfillment / delivery date shown on the web PDP.
              Rules: in stock at pickup store -> 2h (or next open); at DC ->
              +2 business days; else +7. No carrier, no cutoff, no capacity.
   Change log:
     2019-06-17  PN   Initial version
     2023-10-02  PN   DC stock counts for ship-to-home
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Fulfillment_EstimateDate', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Fulfillment_EstimateDate
GO
CREATE PROCEDURE dbo.usp_Fulfillment_EstimateDate
    @skuID CHAR(32),
    @storeNumber TINYINT = NULL,
    @quantity INT = 1,
    @estimate DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @storeLoc CHAR(32), @dcLoc CHAR(32), @qStore INT = 0, @qDC INT = 0, @now DATETIME = GETDATE()
    SELECT @storeLoc = locationID FROM dbo.SwStoreProfile WHERE StoreNumber = @storeNumber
    SELECT TOP 1 @dcLoc = locationID FROM dbo.SwDistributionCenter WHERE PrimaryFlag = 1
    SELECT @qStore = ISNULL(calculatedQATS, 0) FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @storeLoc   -- cached value, may be stale until the nightly batch
    SELECT @qDC = ISNULL(calculatedQATS, 0) FROM dbo.SwStock WHERE skuID = @skuID AND locationID = @dcLoc
    IF @storeNumber IS NOT NULL AND @qStore >= @quantity
        SET @estimate = CASE WHEN dbo.fn_Store_IsOpen(@storeNumber, DATEADD(HOUR, 2, @now)) = 1 THEN DATEADD(HOUR, 2, @now) ELSE DATEADD(DAY, 1, CAST(CAST(@now AS DATE) AS DATETIME)) + 10.0/24 END
    ELSE IF @qDC >= @quantity
        SET @estimate = DATEADD(DAY, CASE DATEPART(WEEKDAY, @now) WHEN 6 THEN 4 WHEN 7 THEN 3 ELSE 2 END, CAST(CAST(@now AS DATE) AS DATETIME))
    ELSE
        SET @estimate = DATEADD(DAY, 7, CAST(CAST(@now AS DATE) AS DATETIME))
END
GO
