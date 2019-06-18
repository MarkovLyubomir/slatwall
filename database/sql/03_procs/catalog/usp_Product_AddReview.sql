/* =============================================================================
   Procedure: dbo.usp_Product_AddReview
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Web product review (moderated: activeFlag = 0 until approved).
   Change log:
     2019-06-17  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Product_AddReview', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Product_AddReview
GO
CREATE PROCEDURE dbo.usp_Product_AddReview
    @productID CHAR(32),
    @accountID CHAR(32) = NULL,
    @reviewerName VARCHAR(255),
    @reviewTitle VARCHAR(255),
    @review VARCHAR(4000),
    @rating INT
AS
BEGIN
    SET NOCOUNT ON
    IF @rating < 1 OR @rating > 5 BEGIN RAISERROR('Rating must be 1-5', 16, 1) RETURN END
    INSERT dbo.SwProductReview (productReviewID, activeFlag, reviewerName, review, reviewTitle, rating, productID, accountID, createdDateTime, modifiedDateTime)
    VALUES (dbo.fn_NewID32(), 0, @reviewerName, @review, @reviewTitle, @rating, @productID, @accountID, GETDATE(), GETDATE())
END
GO
