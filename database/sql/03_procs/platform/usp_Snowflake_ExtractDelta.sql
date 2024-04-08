/* =============================================================================
   Procedure: dbo.usp_Snowflake_ExtractDelta
   Author:    Priscilla Nance
   Created:   2024-04-08
   Purpose:   Pre-Fivetran stopgap: write changed rows for orders/items/stock to
              the extract tables the Snowflake loader reads. Fivetran CDC went
              live on BisTrack in 2025 but not on this database, so this still
              runs and Snowflake has both.
   Change log:
     2024-04-08  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Snowflake_ExtractDelta', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Snowflake_ExtractDelta
GO
CREATE PROCEDURE dbo.usp_Snowflake_ExtractDelta
    @since DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF @since IS NULL SELECT @since = ISNULL(MAX(FinishedOn), '2024-01-01') FROM dbo.SwETL_Log WHERE JobName = 'usp_Snowflake_ExtractDelta' AND Status = 'OK'
    IF OBJECT_ID('dbo.SF_Extract_Order') IS NULL
        CREATE TABLE dbo.SF_Extract_Order (orderID CHAR(32), orderNumber VARCHAR(255), accountID CHAR(32), locationID CHAR(32), statusCode VARCHAR(50), originType VARCHAR(255), orderOpenDateTime DATETIME, orderCloseDateTime DATETIME, calculatedTotal DECIMAL(19,2), modifiedDateTime DATETIME, extractedOn DATETIME)
    IF OBJECT_ID('dbo.SF_Extract_OrderItem') IS NULL
        CREATE TABLE dbo.SF_Extract_OrderItem (orderItemID CHAR(32), orderID CHAR(32), skuCode VARCHAR(50), quantity INT, price DECIMAL(19,2), modifiedDateTime DATETIME, extractedOn DATETIME)
    INSERT dbo.SF_Extract_Order SELECT o.orderID, o.orderNumber, o.accountID, o.locationID, t.systemCode, oo.orderOriginType, o.orderOpenDateTime, o.orderCloseDateTime, o.calculatedTotal, o.modifiedDateTime, GETDATE()
    FROM dbo.SwOrder o WITH (NOLOCK) JOIN dbo.SwType t ON t.typeID = o.orderStatusTypeID LEFT JOIN dbo.SwOrderOrigin oo ON oo.orderOriginID = o.orderOriginID WHERE o.modifiedDateTime > @since
    INSERT dbo.SF_Extract_OrderItem SELECT oi.orderItemID, oi.orderID, s.skuCode, oi.quantity, oi.price, oi.modifiedDateTime, GETDATE()
    FROM dbo.SwOrderItem oi WITH (NOLOCK) JOIN dbo.SwSku s ON s.skuID = oi.skuID WHERE oi.modifiedDateTime > @since
    INSERT dbo.SwETL_Log (JobName, StepName, RowsAffected, Status, FinishedOn) VALUES ('usp_Snowflake_ExtractDelta', 'delta', @@ROWCOUNT, 'OK', GETDATE())
END
GO
