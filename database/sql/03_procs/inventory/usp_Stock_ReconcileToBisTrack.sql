/* =============================================================================
   Procedure: dbo.usp_Stock_ReconcileToBisTrack
   Author:    Wade Hollister
   Created:   2017-10-30
   Purpose:   Compare our QOH to the BisTrack on-hand extract (##BT_OnHand) and
              report variances > 2 units. Nobody actions the output; it emails
              a CSV to inventory-control@ which has 2,000 unread copies.
   Change log:
     2017-10-30  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Stock_ReconcileToBisTrack', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Stock_ReconcileToBisTrack
GO
CREATE PROCEDURE dbo.usp_Stock_ReconcileToBisTrack
AS
BEGIN
    SET NOCOUNT ON
    IF OBJECT_ID('tempdb..##BT_OnHand') IS NULL RETURN
    SELECT s.skuCode, sp.StoreNumber, st.calculatedQOH AS SWC_QOH, bt.OnHand AS BT_QOH, st.calculatedQOH - bt.OnHand AS Variance
    INTO #var
    FROM dbo.SwStock st JOIN dbo.SwSku s ON s.skuID = st.skuID JOIN dbo.SwStoreProfile sp ON sp.locationID = st.locationID
    JOIN ##BT_OnHand bt ON bt.ItemNo = s.skuCode AND bt.Branch = sp.StoreNumber
    WHERE ABS(st.calculatedQOH - bt.OnHand) > 2
    EXEC msdb.dbo.sp_send_dbmail @profile_name = 'SWC', @recipients = 'inventory-control@slatwall.com', @subject = 'SWC/BT on-hand variances',
         @query = 'SELECT * FROM #var ORDER BY ABS(Variance) DESC', @attach_query_result_as_file = 1, @query_attachment_filename = 'variances.csv'
    DROP TABLE #var
END
GO
