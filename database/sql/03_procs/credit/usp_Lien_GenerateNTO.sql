/* =============================================================================
   Procedure: dbo.usp_Lien_GenerateNTO
   Author:    Wade Hollister
   Created:   2016-09-13
   Purpose:   Queue a notice-to-owner letter for jobs whose NTO deadline is within
              10 days and nothing has been filed. Writes the letter body with
              FOR XML PATH string building and shells out to print.
   Change log:
     2016-09-13  WH   Initial version
     2018-04-02  WH   xp_cmdshell print to the Greensboro credit printer
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Lien_GenerateNTO', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Lien_GenerateNTO
GO
CREATE PROCEDURE dbo.usp_Lien_GenerateNTO
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @jobAccountID INT, @body VARCHAR(MAX), @cmd VARCHAR(500), @path VARCHAR(200)
    DECLARE c CURSOR LOCAL FOR
        SELECT JobAccountID FROM dbo.SwJobAccount WHERE JobStatus = 'OPEN' AND NTODeadline IS NOT NULL AND NTOFiledDate IS NULL AND NTODeadline <= DATEADD(DAY, 10, GETDATE())
    OPEN c
    FETCH NEXT FROM c INTO @jobAccountID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @body = (SELECT 'NOTICE TO OWNER - ' + j.JobName + ' - ' + j.JobAddress1 + ', ' + j.JobCity + ' ' + j.JobState + CHAR(13) + CHAR(10) +
                               'Owner: ' + ISNULL(j.OwnerName, 'UNKNOWN') + CHAR(13) + CHAR(10) + 'GC: ' + ISNULL(j.GCName, 'UNKNOWN') + CHAR(13) + CHAR(10) +
                               'Supplier: Slatwall Building Supply Co., 4400 Gateway Center Blvd, Greensboro NC 27407' + CHAR(13) + CHAR(10) +
                               'Account: ' + pa.CompanyName + ' (' + ISNULL(pa.BTCustomerNo, '') + ')'
                        FROM dbo.SwJobAccount j JOIN dbo.SwProAccount pa ON pa.ProAccountID = j.ProAccountID WHERE j.JobAccountID = @jobAccountID
                        FOR XML PATH(''))
        IF NOT EXISTS (SELECT 1 FROM dbo.SwLienNotice WHERE JobAccountID = @jobAccountID AND NoticeType = 'NTO')
            INSERT dbo.SwLienNotice (JobAccountID, NoticeType, StateCode, DeadlineDate, Status) SELECT @jobAccountID, 'NTO', JobState, NTODeadline, 'QUEUED' FROM dbo.SwJobAccount WHERE JobAccountID = @jobAccountID
        ELSE
            UPDATE dbo.SwLienNotice SET Status = 'QUEUED' WHERE JobAccountID = @jobAccountID AND NoticeType = 'NTO' AND Status = 'PENDING'

        SET @path = '\\gso-fs01\credit\nto\NTO_' + CAST(@jobAccountID AS VARCHAR(10)) + '.txt'
        SET @cmd = 'echo ' + REPLACE(REPLACE(@body, CHAR(13) + CHAR(10), ' '), '"', '') + ' > "' + @path + '" && print /D:\\gso-ps01\CREDIT-HP4 "' + @path + '"'
        EXEC master..xp_cmdshell @cmd, no_output
        FETCH NEXT FROM c INTO @jobAccountID
    END
    CLOSE c DEALLOCATE c
END
GO
