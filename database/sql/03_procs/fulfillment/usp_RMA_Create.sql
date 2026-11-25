/* =============================================================================
   Procedure: dbo.usp_RMA_Create
   Author:    Priscilla Nance
   Created:   2020-07-06
   Purpose:   Ecommerce RMA request (CUS-204 §7) - creates the RMA record only;
              the return order is created when goods arrive (usp_Order_CreateReturn).
   Change log:
     2020-07-06  PN   Initial version
     2022-05-02  PN   Warranty routing: manufacturer vendor no on the RMA
   ============================================================================= */
IF OBJECT_ID('dbo.usp_RMA_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_RMA_Create
GO
CREATE PROCEDURE dbo.usp_RMA_Create
    @orderID CHAR(32),
    @rmaType VARCHAR(12),          -- RETURN, WARRANTY, DAMAGE
    @reasonCode VARCHAR(10),
    @skuID CHAR(32) = NULL,
    @rmaID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @vendorNo VARCHAR(20), @no VARCHAR(20), @nonReturnable BIT = 0, @days INT
    SELECT @days = DATEDIFF(DAY, orderCloseDateTime, GETDATE()) FROM dbo.SwOrder WHERE orderID = @orderID
    IF @rmaType = 'RETURN' AND @days > 90 SET @nonReturnable = 1
    IF @rmaType = 'WARRANTY' AND @skuID IS NOT NULL
        SELECT TOP 1 @vendorNo = v.accountNumber FROM dbo.SwSku s JOIN dbo.SwVendorProduct vp ON vp.productID = s.productID JOIN dbo.SwVendor v ON v.vendorID = vp.vendorID WHERE s.skuID = @skuID
    SET @no = 'RMA' + CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4)
    INSERT dbo.SwRMA (RMANumber, orderID, RMAType, ReasonCode, NonReturnableFlag, WarrantyVendorNo, Status, RestockingFeePct)
    VALUES (@no, @orderID, @rmaType, @reasonCode, @nonReturnable, @vendorNo, CASE WHEN @nonReturnable = 1 THEN 'REJECTED' ELSE 'REQUESTED' END, CASE @rmaType WHEN 'RETURN' THEN 15.00 ELSE 0 END)
    SET @rmaID = SCOPE_IDENTITY()
END
GO
