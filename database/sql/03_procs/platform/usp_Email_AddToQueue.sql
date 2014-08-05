/* =============================================================================
   Procedure: dbo.usp_Email_AddToQueue
   Author:    Wade Hollister
   Created:   2014-08-05
   Purpose:   Queue an email from a template code (SwEmailTemplate). The CF app
              polls SwEmail and sends via SMTP. Template merge is a REPLACE of
              {{relatedObjectID}} only.
   Change log:
     2014-08-05  WH   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Email_AddToQueue', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Email_AddToQueue
GO
CREATE PROCEDURE dbo.usp_Email_AddToQueue
    @emailTo VARCHAR(255),
    @templateCode VARCHAR(255),
    @relatedObject VARCHAR(255) = NULL,
    @relatedObjectID VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subject VARCHAR(255), @html VARCHAR(MAX), @text VARCHAR(MAX), @from VARCHAR(255)
    IF @emailTo IS NULL RETURN
    SELECT TOP 1 @html = emailBodyHTML, @text = emailBodyText FROM dbo.SwEmailTemplate WHERE emailTemplateName = @templateCode
    -- subject = template's text body first line; from address is a setting (Slatwall templates have no subject column)
    SET @subject = ISNULL(LEFT(@text, CHARINDEX(CHAR(10), @text + CHAR(10)) - 1), @templateCode)
    SET @from = dbo.fn_SettingValue('emailFromAddress')
    IF @html IS NULL SET @html = @templateCode
    INSERT dbo.SwEmail (emailID, emailTo, emailFrom, emailSubject, emailBodyHTML, emailBodyText, relatedObject, relatedObjectID, createdDateTime)
    VALUES (dbo.fn_NewID32(), @emailTo, ISNULL(@from, 'noreply@slatwall.com'), @subject, REPLACE(@html, '{{relatedObjectID}}', ISNULL(@relatedObjectID, '')), @text, @relatedObject, @relatedObjectID, GETDATE())
END
GO
