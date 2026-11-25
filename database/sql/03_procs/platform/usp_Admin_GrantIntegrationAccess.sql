/* =============================================================================
   Procedure: dbo.usp_Admin_GrantIntegrationAccess
   Author:    Wade Hollister
   Created:   2016-08-15
   Purpose:   Create the SQL login for a new integration service account and
              make it db_owner "until we get the roles sorted" (TR-08).
              Password is passed in clear and ends up in SwServiceAccount.Purpose
              because the column was handy.
   Change log:
     2016-08-15  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Admin_GrantIntegrationAccess', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Admin_GrantIntegrationAccess
GO
CREATE PROCEDURE dbo.usp_Admin_GrantIntegrationAccess
    @loginName VARCHAR(60),
    @password VARCHAR(100),
    @purpose VARCHAR(100),
    @owner VARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = N'IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = ''' + @loginName + N''') CREATE LOGIN ' + QUOTENAME(@loginName) + N' WITH PASSWORD = ''' + @password + N''', CHECK_POLICY = OFF;'
             + N'IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''' + @loginName + N''') CREATE USER ' + QUOTENAME(@loginName) + N' FOR LOGIN ' + QUOTENAME(@loginName) + N';'
             + N'ALTER ROLE db_owner ADD MEMBER ' + QUOTENAME(@loginName) + N';'
    EXEC sp_executesql @sql
    INSERT dbo.SwServiceAccount (LoginName, Purpose, Owner) VALUES (@loginName, @purpose + ' / pw: ' + @password, @owner)
END
GO
