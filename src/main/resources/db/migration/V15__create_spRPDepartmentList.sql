USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPDepartmentList]    Script Date: 4/3/2019 10:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
2018-12-20  Precious	PAT ..  Select a list of departments
**********************************************************************************************/
CREATE PROCEDURE [dbo].[spRPDepartmentList]
AS
BEGIN

  SELECT ROW_NUMBER() OVER(ORDER BY code,name) id,code,name
  FROM (
  SELECT '' code, 'All Departments' name

  UNION
	SELECT   chDepartmentCode +'|'+ chDisciplineType code ,
			vchNameEng name
	FROM RS.dbo.tblDepartment (NOLOCK)
	WHERE chDepartmentCode <> '0')AS tblInner

	ORDER BY name


END