/* =============================================================================
   Function:  dbo.fn_Stock_QOH
   Author:    Wade Hollister
   Created:   2014-04-22
   Purpose:   Quantity on hand from the SwInventory ledger for a stock row.
              This is the "true" number; SwStock.calculatedQOH is the cached one.
   Change log:
     2014-04-22  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_Stock_QOH') IS NOT NULL DROP FUNCTION dbo.fn_Stock_QOH
GO
CREATE FUNCTION dbo.fn_Stock_QOH(@stockID CHAR(32))
RETURNS INT
AS
BEGIN
    RETURN (SELECT ISNULL(SUM(quantityIn), 0) - ISNULL(SUM(quantityOut), 0)
            FROM dbo.SwInventory WHERE stockID = @stockID)
END
GO
