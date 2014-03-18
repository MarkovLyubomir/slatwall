/* =============================================================================
   Procedure: dbo.usp_Attr_SetValue
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Set an EAV attribute value on any object (sku, product, order,
              account...). One nullable FK column per object type on SwAttributeValue.
   Change log:
     2014-03-18  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Attr_SetValue', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Attr_SetValue
GO
CREATE PROCEDURE dbo.usp_Attr_SetValue
    @attributeCode VARCHAR(255),
    @objectType VARCHAR(30),      -- sku, product, order, orderItem, account, vendor, location
    @objectID CHAR(32),
    @value VARCHAR(4000)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @attrID CHAR(32), @sql NVARCHAR(MAX), @col SYSNAME
    SELECT TOP 1 @attrID = attributeID FROM dbo.SwAttribute WHERE attributeCode = @attributeCode
    IF @attrID IS NULL
    BEGIN
        SET @attrID = dbo.fn_NewID32()
        INSERT dbo.SwAttribute (attributeID, activeFlag, attributeName, attributeCode, attributeInputType, requiredFlag, createdDateTime, modifiedDateTime) VALUES (@attrID, 1, @attributeCode, @attributeCode, 'text', 0, GETDATE(), GETDATE())
    END
    SET @col = @objectType + 'ID'
    SET @sql = N'DELETE dbo.SwAttributeValue WHERE attributeID = @a AND ' + QUOTENAME(@col) + N' = @o;'
             + N'INSERT dbo.SwAttributeValue (attributeValueID, attributeValue, attributeID, ' + QUOTENAME(@col) + N', createdDateTime) VALUES (dbo.fn_NewID32(), @v, @a, @o, GETDATE())'
    EXEC sp_executesql @sql, N'@a CHAR(32), @o CHAR(32), @v VARCHAR(4000)', @attrID, @objectID, @value
END
GO
