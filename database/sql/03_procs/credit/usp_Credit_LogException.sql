/* =============================================================================
   Procedure: dbo.usp_Credit_LogException
   Author:    Wade Hollister
   Created:   2017-01-23
   Purpose:   Write to the credit exception log. Originally wrote to the Access
              database CreditExceptions.accdb over a linked server; since 2023
              the table lives here but kept its shape. Dynamic SQL because the
              Access columns had spaces at one point.
   Change log:
     2017-01-23  WH   Initial version (linked server [ACCESS_CREDIT])
     2023-03-06  WH   Table imported to SlatwallCommerce; linked server path kept as fallback
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Credit_LogException', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Credit_LogException
GO
CREATE PROCEDURE dbo.usp_Credit_LogException
    @custNo VARCHAR(20),
    @excType VARCHAR(30),
    @amt MONEY,
    @approvedBy VARCHAR(30),
    @store VARCHAR(5),
    @memo VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @sql NVARCHAR(MAX), @custName VARCHAR(100)
    SELECT TOP 1 @custName = CompanyName FROM dbo.SwProAccount WHERE BTCustomerNo = @custNo
    SET @sql = N'INSERT INTO dbo.tblCreditException (CustNo, CustName, ExcDate, ExcType, Amt, ApprovedBy, Store, Memo, Resolved, EnteredBy) VALUES ('''
             + @custNo + N''',''' + REPLACE(ISNULL(@custName, ''), '''', '''''') + N''', GETDATE(), ''' + @excType + N''', ' + CAST(@amt AS NVARCHAR(20)) + N', '''
             + @approvedBy + N''',''' + @store + N''',''' + REPLACE(ISNULL(@memo, ''), '''', '''''') + N''', 0, ''' + SUSER_SNAME() + N''')'
    BEGIN TRY
        EXEC (@sql)
    END TRY
    BEGIN CATCH
        -- fallback to the old Access path (linked server was removed in 2024, this always fails now)
        SET @sql = REPLACE(@sql, 'dbo.tblCreditException', '[ACCESS_CREDIT]...[tblCreditException]')
        EXEC (@sql)
    END CATCH
END
GO
