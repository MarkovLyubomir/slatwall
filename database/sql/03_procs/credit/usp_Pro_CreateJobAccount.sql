/* =============================================================================
   Procedure: dbo.usp_Pro_CreateJobAccount
   Author:    Wade Hollister
   Created:   2016-03-14
   Purpose:   Create a job account under a pro account (SAL-106 §4, SAL-205 §3)
              and compute the lien/notice deadlines for the job state.
   Change log:
     2016-03-14  WH   Initial version
     2016-09-13  WH   NTO / lien deadlines
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Pro_CreateJobAccount', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Pro_CreateJobAccount
GO
CREATE PROCEDURE dbo.usp_Pro_CreateJobAccount
    @proAccountID INT,
    @jobName VARCHAR(120),
    @jobAddress1 VARCHAR(100),
    @jobCity VARCHAR(40),
    @jobState CHAR(2),
    @jobZip VARCHAR(10),
    @ownerName VARCHAR(120) = NULL,
    @gcName VARCHAR(120) = NULL,
    @jobBudget DECIMAL(19,2) = NULL,
    @jobStartDate DATE = NULL,
    @publicWorkFlag BIT = 0,
    @jobAccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @btCust VARCHAR(20), @seq INT, @jobNo VARCHAR(20), @ntoDays INT, @lienDays INT
    SELECT @btCust = BTCustomerNo FROM dbo.SwProAccount WHERE ProAccountID = @proAccountID
    SELECT @seq = COUNT(*) + 1 FROM dbo.SwJobAccount WHERE ProAccountID = @proAccountID
    SET @jobNo = ISNULL(@btCust, CAST(@proAccountID AS VARCHAR(10))) + '-J' + RIGHT('00' + CAST(@seq AS VARCHAR(3)), 3)
    SET @ntoDays = dbo.fn_Lien_StateDeadlineDays(@jobState, 'NTO')
    SET @lienDays = dbo.fn_Lien_StateDeadlineDays(@jobState, 'LIEN')
    INSERT dbo.SwJobAccount (ProAccountID, JobNumber, JobName, JobAddress1, JobCity, JobState, JobZip, OwnerName, GCName, JobBudget, JobStartDate, PublicWorkFlag, JobStatus, BTJobNo,
                             NTODeadline, LienDeadline)
    VALUES (@proAccountID, @jobNo, @jobName, @jobAddress1, @jobCity, @jobState, @jobZip, @ownerName, @gcName, @jobBudget, @jobStartDate, @publicWorkFlag, 'OPEN', @jobNo,
            CASE WHEN @jobStartDate IS NOT NULL THEN DATEADD(DAY, @ntoDays, @jobStartDate) END,
            CASE WHEN @jobStartDate IS NOT NULL THEN DATEADD(DAY, @lienDays, @jobStartDate) END)
    SET @jobAccountID = SCOPE_IDENTITY()
    IF @jobState = 'TN' OR @publicWorkFlag = 1
        INSERT dbo.SwLienNotice (JobAccountID, NoticeType, StateCode, DeadlineDate, Status) VALUES (@jobAccountID, 'NTO', @jobState, DATEADD(DAY, @ntoDays, ISNULL(@jobStartDate, GETDATE())), 'PENDING')
END
GO
