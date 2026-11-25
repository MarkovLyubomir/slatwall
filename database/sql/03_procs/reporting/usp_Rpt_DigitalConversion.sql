/* =============================================================================
   Procedure: dbo.usp_Rpt_DigitalConversion
   Author:    Priscilla Nance
   Created:   2019-06-17
   Purpose:   Web conversion = placed web orders / sessions with a cart, from
              SwSession (which the CF app writes). Target 2.10%. Adobe Analytics
              reports a different number because it counts sessions differently.
   Change log:
     2019-06-17  PN   Initial version
   ============================================================================= */
IF OBJECT_ID('dbo.usp_Rpt_DigitalConversion', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Rpt_DigitalConversion
GO
CREATE PROCEDURE dbo.usp_Rpt_DigitalConversion
    @from DATE,
    @to DATE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @sessions INT, @orders INT
    SELECT @sessions = COUNT(*) FROM dbo.SwSession WITH (NOLOCK) WHERE createdDateTime BETWEEN @from AND @to AND orderID IS NOT NULL
    SELECT @orders = COUNT(*) FROM dbo.SwOrder o WITH (NOLOCK) JOIN dbo.SwOrderOrigin oo ON oo.orderOriginID = o.orderOriginID
    WHERE oo.orderOriginType = 'web' AND o.orderOpenDateTime BETWEEN @from AND @to AND o.orderNumber IS NOT NULL
    SELECT @sessions AS CartSessions, @orders AS WebOrders, CASE WHEN @sessions > 0 THEN ROUND(100.0 * @orders / @sessions, 2) END AS ConversionPct, 2.10 AS Target
END
GO
