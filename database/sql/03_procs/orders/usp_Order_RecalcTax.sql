/* =============================================================================
   Procedure: dbo.usp_Order_RecalcTax
   Author:    Wade Hollister
   Created:   2015-06-08
   Purpose:   Wrapper kept for the admin "recalculate tax" button.
   Change log:
     2015-06-08  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_RecalcTax', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_RecalcTax
GO
CREATE PROCEDURE dbo.usp_Order_RecalcTax
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    EXEC dbo.usp_Tax_Calculate @orderID
    EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
END
GO
