/* =============================================================================
   Procedure: dbo.usp_Lien_CalcNoticeDeadline
   Author:    Wade Hollister
   Created:   2016-09-13
   Purpose:   (Re)compute NTO and lien deadlines for a job from first delivery.
   Change log:
     2016-09-13  WH   Initial version
     2019-03-11  WH   First delivery date from SwDeliveryStop if not set
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Lien_CalcNoticeDeadline', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Lien_CalcNoticeDeadline
GO
CREATE PROCEDURE dbo.usp_Lien_CalcNoticeDeadline
    @jobAccountID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @state CHAR(2), @first DATE
    SELECT @state = JobState, @first = FirstDeliveryDate FROM dbo.SwJobAccount WHERE JobAccountID = @jobAccountID
    IF @first IS NULL
        SELECT @first = MIN(CAST(ds.CompletedOn AS DATE)) FROM dbo.SwDeliveryStop ds JOIN dbo.SwWillCallRelease wr ON wr.orderID = ds.orderID WHERE wr.JobAccountID = @jobAccountID
    IF @first IS NULL RETURN
    UPDATE dbo.SwJobAccount SET FirstDeliveryDate = @first,
        NTODeadline = DATEADD(DAY, dbo.fn_Lien_StateDeadlineDays(@state, 'NTO'), @first),
        LienDeadline = DATEADD(DAY, dbo.fn_Lien_StateDeadlineDays(@state, 'LIEN'), @first),
        UpdatedOn = GETDATE()
    WHERE JobAccountID = @jobAccountID
END
GO
