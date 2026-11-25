/* =============================================================================
   Procedure: dbo.usp_Account_Create
   Author:    Wade Hollister
   Created:   2014-03-18
   Purpose:   Create a SwAccount with primary email. Called by web import, POS
              import, the admin, and the BisTrack customer sync - each passes a
              different remote id, hence three remote*ID columns.
   Change log:
     2014-03-18  WH   Initial version
     2018-11-26  PN   @remoteCustomerID (Adobe)
     2021-02-22  WH   @remoteContactID (Salesforce)
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Account_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Account_Create
GO
CREATE PROCEDURE dbo.usp_Account_Create
    @firstName VARCHAR(255) = NULL,
    @lastName VARCHAR(255) = NULL,
    @company VARCHAR(255) = NULL,
    @emailAddress VARCHAR(255) = NULL,
    @remoteID VARCHAR(255) = NULL,            -- BisTrack customer no
    @remoteCustomerID VARCHAR(255) = NULL,    -- Adobe customer id
    @remoteContactID VARCHAR(255) = NULL,     -- Salesforce contact id
    @accountID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @emailID CHAR(32)
    SET @accountID = dbo.fn_NewID32()
    INSERT dbo.SwAccount (accountID, superUserFlag, firstName, lastName, company, taxExemptFlag, failedLoginAttemptCount, remoteID, remoteCustomerID, remoteContactID, createdDateTime, modifiedDateTime)
    VALUES (@accountID, 0, @firstName, @lastName, @company, 0, 0, @remoteID, @remoteCustomerID, @remoteContactID, GETDATE(), GETDATE())
    IF @emailAddress IS NOT NULL
    BEGIN
        SET @emailID = dbo.fn_NewID32()
        INSERT dbo.SwAccountEmailAddress (accountEmailAddressID, emailAddress, verifiedFlag, accountID, createdDateTime, modifiedDateTime) VALUES (@emailID, @emailAddress, 0, @accountID, GETDATE(), GETDATE())
        UPDATE dbo.SwAccount SET primaryEmailAddressID = @emailID WHERE accountID = @accountID
    END
END
GO
