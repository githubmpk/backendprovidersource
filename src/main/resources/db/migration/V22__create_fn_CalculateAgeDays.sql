   USE [ResultsPortal]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CalculateAgeDays]    Script Date: 4/3/2019 10:53:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************
2017-02-13	Precious	Calculate current age days from date of birth
**********************************************************/
CREATE FUNCTION [dbo].[fn_CalculateAgeDays] (@date DATETIME)

RETURNS INTEGER
AS
BEGIN
	DECLARE  @tmpdate DATETIME, @years INT, @months INT, @days INT
SELECT @tmpdate = @date
SELECT @years = DATEDIFF(yy, @tmpdate, GETDATE()) - CASE WHEN (MONTH(@date) > MONTH(GETDATE())) OR (MONTH(@date) = MONTH(GETDATE()) AND DAY(@date) > DAY(GETDATE())) THEN 1 ELSE 0 END
SELECT @tmpdate = DATEADD(yy, @years, @tmpdate)
SELECT @months = DATEDIFF(m, @tmpdate, GETDATE()) - CASE WHEN DAY(@date) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tmpdate = DATEADD(m, @months, @tmpdate)
SELECT @days = DATEDIFF(d, @tmpdate, GETDATE())

RETURN @days

END