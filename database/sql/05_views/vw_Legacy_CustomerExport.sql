/* =============================================================================
   View:      dbo.vw_Legacy_CustomerExport
   Author:    Epicor PS (migration)
   Created:   2014-03-04
   Purpose:   Export used by the 2014 migration to seed BisTrack customer notes.
              Nothing has selected from it since 2014 (sys.dm_db_index_usage_stats
              confirms); kept "just in case".
   Change log:
     2014-03-04  EPS  Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_Legacy_CustomerExport', 'V') IS NOT NULL DROP VIEW dbo.vw_Legacy_CustomerExport
GO
CREATE VIEW dbo.vw_Legacy_CustomerExport AS
SELECT a.accountID, a.firstName + ' ' + a.lastName AS fullName, a.company, a.cmsAccountID, a.createdDateTime
FROM dbo.SwAccount a
GO
