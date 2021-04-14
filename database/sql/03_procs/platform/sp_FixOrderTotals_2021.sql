/* =============================================================================
   Procedure: dbo.sp_FixOrderTotals_2021
   Author:    R. Oduya (TekSystems)
   Created:   2021-04-13
   Purpose:   One-off: recompute calculatedTotal for orders affected by the
              duplicate-line bug (ticket 3920). Was supposed to be dropped after
              the run. Still here; still in the deployment script.
   Change log:
     2021-04-13  RO   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.sp_FixOrderTotals_2021', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_FixOrderTotals_2021
GO
CREATE PROCEDURE dbo.sp_FixOrderTotals_2021
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @orderID CHAR(32)
    DECLARE c CURSOR FOR SELECT orderID FROM dbo.SwOrder WHERE orderOpenDateTime BETWEEN '2021-03-01' AND '2021-04-13'
    OPEN c
    FETCH NEXT FROM c INTO @orderID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_Order_UpdateOrderAmounts @orderID
        FETCH NEXT FROM c INTO @orderID
    END
    CLOSE c DEALLOCATE c
END
GO
