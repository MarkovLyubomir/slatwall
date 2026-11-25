/* =============================================================================
   Procedure: dbo.usp_VendorOrder_Create
   Author:    Wade Hollister
   Created:   2014-09-15
   Purpose:   Create a purchase order header (Slatwall VendorOrder) for a vendor
              and receiving location.
   Change log:
     2014-09-15  WH   Initial version
     2018-07-02  WH   PO number from BisTrack range (SwSetting 'poNumberSeq')
   ============================================================================= */
IF OBJECT_ID('dbo.usp_VendorOrder_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_VendorOrder_Create
GO
CREATE PROCEDURE dbo.usp_VendorOrder_Create
    @vendorID CHAR(32),
    @locationID CHAR(32),
    @estimatedReceival DATETIME = NULL,
    @vendorOrderID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @seq INT
    UPDATE dbo.SwSetting SET settingValue = CAST(CAST(settingValue AS INT) + 1 AS VARCHAR(20)), @seq = CAST(settingValue AS INT) + 1 WHERE settingName = 'poNumberSeq'
    SET @vendorOrderID = dbo.fn_NewID32()
    INSERT dbo.SwVendorOrder (vendorOrderID, vendorOrderNumber, estimatedReceivalDateTime, currencyCode, locationID, vendorID, vendorOrderTypeID, vendorOrderStatusTypeID, createdDateTime, modifiedDateTime)
    VALUES (@vendorOrderID, 'PO' + CAST(ISNULL(@seq, 0) AS VARCHAR(10)), @estimatedReceival, 'USD', @locationID, @vendorID,
            dbo.fn_GetTypeID('vendorOrderType','votPurchaseOrder'), dbo.fn_GetTypeID('vendorOrderStatusType','vostNew'), GETDATE(), GETDATE())
END
GO
