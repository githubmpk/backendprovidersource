USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPProfileList]    Script Date: 4/3/2019 10:50:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
2018-12-01	Precious	PAT-xx		Select a list of test profiles
**********************************************************************************************/
CREATE PROCEDURE [dbo].[spRPProfileList]  AS
SET NOCOUNT ON
BEGIN
	 SELECT ROW_NUMBER() OVER(ORDER BY code,name) id,code,name
  FROM (

		  SELECT '' code, 'All Profiles' name

		  UNION

		  SELECT  CAST (iId AS VARCHAR) code,vchProfile name
					FROM RS.dbo.tblProfile (NOLOCK)
						WHERE tiActive = 1
							  AND  iId <> 1000000
							  AND vchProfile<>'none'
							  AND tiView =  0
	)AS tblInner
END