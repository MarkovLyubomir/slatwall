/* =============================================================================
   Function:  dbo.fn_SettingValue
   Author:    Wade Hollister
   Created:   2014-03-11
   Purpose:   Read a global setting from SwSetting (name/value strings).
   Change log:
     2014-03-11  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.fn_SettingValue') IS NOT NULL DROP FUNCTION dbo.fn_SettingValue
GO
CREATE FUNCTION dbo.fn_SettingValue(@settingName VARCHAR(255))
RETURNS VARCHAR(4000)
AS
BEGIN
    RETURN (SELECT TOP 1 settingValue FROM dbo.SwSetting
            WHERE settingName = @settingName AND accountID IS NULL AND skuID IS NULL AND productID IS NULL
            ORDER BY modifiedDateTime DESC)
END
GO
