/* =============================================================================
   Procedure: dbo.usp_Vendor_Create
   Author:    Wade Hollister
   Created:   2014-09-15
   Purpose:   Create a vendor with primary email/phone/address rows.
   Change log:
     2014-09-15  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Vendor_Create', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Vendor_Create
GO
CREATE PROCEDURE dbo.usp_Vendor_Create
    @vendorName VARCHAR(255),
    @accountNumber VARCHAR(255) = NULL,      -- BisTrack vendor no
    @emailAddress VARCHAR(255) = NULL,
    @phone VARCHAR(255) = NULL,
    @vendorID CHAR(32) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @emailID CHAR(32), @phoneID CHAR(32)
    SET @vendorID = dbo.fn_NewID32()
    INSERT dbo.SwVendor (vendorID, vendorName, accountNumber, remoteID, createdDateTime, modifiedDateTime) VALUES (@vendorID, @vendorName, @accountNumber, @accountNumber, GETDATE(), GETDATE())
    IF @emailAddress IS NOT NULL
    BEGIN
        SET @emailID = dbo.fn_NewID32()
        INSERT dbo.SwVendorEmailAddress (vendorEmailAddressID, emailAddress, vendorID, createdDateTime, modifiedDateTime) VALUES (@emailID, @emailAddress, @vendorID, GETDATE(), GETDATE())
        UPDATE dbo.SwVendor SET primaryEmailAddressID = @emailID WHERE vendorID = @vendorID
    END
    IF @phone IS NOT NULL
    BEGIN
        SET @phoneID = dbo.fn_NewID32()
        INSERT dbo.SwVendorPhoneNumber (vendorPhoneNumberID, phoneNumber, vendorID, createdDateTime, modifiedDateTime) VALUES (@phoneID, @phone, @vendorID, GETDATE(), GETDATE())
        UPDATE dbo.SwVendor SET primaryPhoneNumberID = @phoneID WHERE vendorID = @vendorID
    END
END
GO
