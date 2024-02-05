/* =============================================================================
   Procedure: dbo.usp_Pro_CalcTTMPurchases
   Author:    Wade Hollister
   Created:   2024-02-05
   Purpose:   Trailing-twelve-month purchases per pro account from closed orders
              (all channels) - the basis for annual re-tiering.
   NOTE:      Uses SwOrder.calculatedTotal which includes tax and delivery; the
              playbook says merchandise only. FP&A reconciles by hand.
   Change log:
     2024-02-05  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pro_CalcTTMPurchases', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pro_CalcTTMPurchases
GO
CREATE PROCEDURE dbo.usp_Pro_CalcTTMPurchases
    @asOf DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @asOf IS NULL SET @asOf = CAST(GETDATE() AS DATE)
    UPDATE pa SET pa.PrevTTMPurchases = pa.TTMPurchases, pa.UpdatedOn = GETDATE(), pa.UpdatedBy = 'usp_Pro_CalcTTMPurchases'
    FROM dbo.SwProAccount pa
    UPDATE pa SET pa.TTMPurchases = x.ttm
    FROM dbo.SwProAccount pa
    JOIN (SELECT o.accountID, SUM(o.calculatedTotal) AS ttm FROM dbo.SwOrder o WITH (NOLOCK)
          WHERE o.orderStatusTypeID = dbo.fn_GetTypeID('orderStatusType','ostClosed') AND o.orderTypeID = dbo.fn_GetTypeID('orderType','otSalesOrder')
            AND o.orderCloseDateTime > DATEADD(MONTH, -12, @asOf) AND o.orderCloseDateTime <= @asOf
          GROUP BY o.accountID) x ON x.accountID = pa.accountID
    UPDATE dbo.SwProAccount SET TTMPurchases = 0 WHERE accountID NOT IN (SELECT accountID FROM dbo.SwOrder WHERE orderCloseDateTime > DATEADD(MONTH, -12, @asOf) AND accountID IS NOT NULL)
END
GO
