/* =============================================================================
   Procedure: dbo.usp_Order_SearchByAccount
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Order history for the web "My Orders" page. Dynamic SQL for the
              optional filters.
   Change log:
     2019-06-17  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_SearchByAccount', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_SearchByAccount
GO
CREATE PROCEDURE dbo.usp_Order_SearchByAccount
    @accountID CHAR(32),
    @statusCode VARCHAR(50) = NULL,
    @fromDate DATE = NULL,
    @orderNumberLike VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = N'SELECT o.orderID, o.orderNumber, o.orderOpenDateTime, o.calculatedTotal, t.systemCode AS status
                 FROM dbo.SwOrder o WITH (NOLOCK) JOIN dbo.SwType t ON t.typeID = o.orderStatusTypeID
                 WHERE o.accountID = ''' + @accountID + ''''
    IF @statusCode IS NOT NULL SET @sql = @sql + N' AND t.systemCode = ''' + @statusCode + ''''
    IF @fromDate IS NOT NULL SET @sql = @sql + N' AND o.orderOpenDateTime >= ''' + CONVERT(VARCHAR(10), @fromDate, 120) + ''''
    IF @orderNumberLike IS NOT NULL SET @sql = @sql + N' AND o.orderNumber LIKE ''%' + @orderNumberLike + N'%'''
    SET @sql = @sql + N' ORDER BY o.orderOpenDateTime DESC'
    EXEC (@sql)
END
GO
