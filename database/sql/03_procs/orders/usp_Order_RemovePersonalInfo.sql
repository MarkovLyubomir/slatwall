/* =============================================================================
   Procedure: dbo.usp_Order_RemovePersonalInfo
   Author:    Priscilla Nance
   Created:   2020-01-14
   Purpose:   "Right to be forgotten" scrub for a closed order (web requests via
              privacy@). Blanks name/address fields in place.
   NOTE:      Does not touch SwAudit, SwEmail or the Snowflake extract. Legal
              knows.
   Change log:
     2020-01-14  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Order_RemovePersonalInfo', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Order_RemovePersonalInfo
GO
CREATE PROCEDURE dbo.usp_Order_RemovePersonalInfo
    @orderID CHAR(32)
AS
BEGIN
    SET NOCOUNT ON
    IF dbo.fn_Order_StatusCode(@orderID) NOT IN ('ostClosed','ostCanceled')
    BEGIN
        RAISERROR('Only closed/canceled orders can be scrubbed', 16, 1)
        RETURN
    END
    UPDATE a SET a.name = 'REDACTED', a.firstName = NULL, a.lastName = NULL, a.company = NULL, a.streetAddress = NULL, a.street2Address = NULL,
                 a.phoneNumber = NULL, a.emailAddress = NULL, a.modifiedDateTime = GETDATE()
    FROM dbo.SwAddress a JOIN dbo.SwOrder o ON a.addressID IN (o.billingAddressID, o.shippingAddressID) WHERE o.orderID = @orderID
    UPDATE dbo.SwOrderFulfillment SET emailAddress = NULL WHERE orderID = @orderID
    UPDATE dbo.SwOrder SET orderOpenIPAddress = NULL, modifiedDateTime = GETDATE() WHERE orderID = @orderID
    UPDATE dbo.SwDeliveryStop SET JobsiteContact = NULL, PODSignature = NULL, PODPhotoRef = NULL WHERE orderID = @orderID
END
GO
