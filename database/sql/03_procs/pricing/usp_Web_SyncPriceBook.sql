/* =============================================================================
   Procedure: dbo.usp_Web_SyncPriceBook
   Author:    Priscilla Nance
   Created:   2018-11-26
   Purpose:   Nightly: compute the web price for every published sku x customer
              group and queue it for Adobe. ~90k rows/night, row by row.
   Change log:
     2018-11-26  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Web_SyncPriceBook', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Web_SyncPriceBook
GO
CREATE PROCEDURE dbo.usp_Web_SyncPriceBook
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @skuID CHAR(32), @grp VARCHAR(20), @price DECIMAL(19,4), @n INT = 0, @start DATETIME = GETDATE()
    DECLARE @groups TABLE (grp VARCHAR(20))
    INSERT @groups VALUES ('RETAIL'), ('PRO1'), ('PRO2'), ('PRO3'), ('PRO4'), ('PRO5')

    DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT skuID FROM dbo.SwSku WHERE publishedFlag = 1 AND activeFlag = 1
    OPEN c
    FETCH NEXT FROM c INTO @skuID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE g CURSOR LOCAL FOR SELECT grp FROM @groups
        OPEN g
        FETCH NEXT FROM g INTO @grp
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC dbo.usp_Web_GetPrice @skuID = @skuID, @customerGroup = @grp, @webPrice = @price OUTPUT
            INSERT dbo.SwWebSync_Price (skuID, PriceZone, CustomerGroup, WebPrice) VALUES (@skuID, 'A', @grp, @price)
            SET @n = @n + 1
            FETCH NEXT FROM g INTO @grp
        END
        CLOSE g DEALLOCATE g
        FETCH NEXT FROM c INTO @skuID
    END
    CLOSE c DEALLOCATE c
    INSERT dbo.SwETL_Log (JobName, StepName, StartedOn, FinishedOn, RowsAffected, Status) VALUES ('usp_Web_SyncPriceBook', 'pricebook', @start, GETDATE(), @n, 'OK')
END
GO
