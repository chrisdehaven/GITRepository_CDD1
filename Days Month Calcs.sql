SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION ufn_DaysLeftWork 
(
	-- Add the parameters for the function here
	@date datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
Declare @DaysLeft as INT

;With MyCTE AS
(
    SELECT number + 1 as 'CurrentDay'
    FROM   master..spt_values
    WHERE  type='p'
    AND    number < datepart(dd, DateAdd(day,-1,DateAdd(Month,1,DateAdd(Month,
                                          DateDiff(Month, 0, GETDATE()),0))))
    AND    datename(WEEKDAY,DateAdd(Month, DateDiff(Month, 0, GETDATE()),
                                         number) ) not in ('Saturday','Sunday')
)

Select @DaysLeft = (Select COUNT(*) As MyTotal from MyCTE
WHERE CurrentDay >= DATEPART(DD, GETDATE()))

	-- Return the result of the function
	RETURN @DaysLeft

END
GO

select dbo.ufn_DaysLeftWork(getdate()) as 'number of days left'

select dbo.ufnworkdays(dbo.ufn_GetFirstDayOfMonth(GETDATE()), dbo.ufn_GetLastDayOfMonth(GETDATE())) as 'number of days in month',


 dbo.ufnworkdays(dbo.ufn_GetFirstDayOfMonth(GETDATE()), dbo.ufn_GetLastDayOfMonth(GETDATE())) - dbo.ufn_DaysLeftWork(getdate()) as 'number of days past'
,
dbo.ufn_DaysLeftWork(getdate()) as 'number of days left'
