/* =============================================================================
   View:      dbo.vw_NewID
   Author:    Wade Hollister
   Created:   2014-03-04
   Purpose:   NEWID() wrapper so fn_NewID32 can be a scalar function.
   Change log:
     2014-03-04  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.vw_NewID', 'V') IS NOT NULL DROP VIEW dbo.vw_NewID
GO
CREATE VIEW dbo.vw_NewID AS SELECT NEWID() AS id
GO
