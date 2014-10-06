/* =============================================================================
   Procedure: dbo.usp_StockAdjustment_Create
   Author:    Wade Hollister
   Created:   2014-10-06
   Purpose:   Stock adjustment header: transfer, manual in, manual out, physical.
   Change log:
     2014-10-06  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_StockAdjustment_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_StockAdjustment_Create
GO
CREATE PROCEDURE dbo.usp_StockAdjustment_Create
    @fromLocationID CHAR(32) = NULL,
    @toLocationID CHAR(32) = NULL,
    @adjustmentType VARCHAR(50) = 'satLocationTransfer',
    @physicalID CHAR(32) = NULL,
    @stockAdjustmentID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET @stockAdjustmentID = dbo.fn_NewID32()
    INSERT dbo.SwStockAdjustment (stockAdjustmentID, fromLocationID, toLocationID, stockAdjustmentTypeID, stockAdjustmentStatusTypeID, physicalID, createdDateTime, modifiedDateTime)
    VALUES (@stockAdjustmentID, @fromLocationID, @toLocationID, dbo.fn_GetTypeID('stockAdjustmentType', @adjustmentType), dbo.fn_GetTypeID('stockAdjustmentStatusType','sastNew'), @physicalID, GETDATE(), GETDATE())
END
GO
