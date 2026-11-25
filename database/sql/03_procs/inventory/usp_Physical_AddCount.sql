/* =============================================================================
   Procedure: dbo.usp_Physical_AddCount
   Author:    Wade Hollister
   Created:   2014-10-06
   Purpose:   Record a count (RF gun upload) against a physical for a location.
              Lines keyed by skuCode as scanned.
   Change log:
     2014-10-06  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Physical_AddCount', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Physical_AddCount
GO
CREATE PROCEDURE dbo.usp_Physical_AddCount
    @physicalID CHAR(32),
    @locationID CHAR(32),
    @countLines VARCHAR(MAX),       -- skuCode=qty;skuCode=qty;...
    @countedBy VARCHAR(50) = NULL,
    @physicalCountID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @line VARCHAR(255), @skuCode VARCHAR(50), @qty INT, @stockID CHAR(32)
    SET @physicalCountID = dbo.fn_NewID32()
    INSERT dbo.SwPhysicalCount (physicalCountID, locationID, physicalID, createdDateTime, createdByAccountID) VALUES (@physicalCountID, @locationID, @physicalID, GETDATE(), @countedBy)
    DECLARE c CURSOR LOCAL FOR SELECT val FROM dbo.fn_SplitString(@countLines, ';')
    OPEN c
    FETCH NEXT FROM c INTO @line
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @skuCode = LEFT(@line, CHARINDEX('=', @line) - 1)
        SET @qty = TRY_CAST(SUBSTRING(@line, CHARINDEX('=', @line) + 1, 20) AS INT)
        SELECT @stockID = st.stockID FROM dbo.SwStock st JOIN dbo.SwSku s ON s.skuID = st.skuID WHERE s.skuCode = @skuCode AND st.locationID = @locationID
        INSERT dbo.SwPhysicalCountItem (physicalCountItemID, quantity, skuCode, physicalCountID, stockID, createdDateTime) VALUES (dbo.fn_NewID32(), @qty, @skuCode, @physicalCountID, @stockID, GETDATE())
        FETCH NEXT FROM c INTO @line
    END
    CLOSE c DEALLOCATE c
END
GO
