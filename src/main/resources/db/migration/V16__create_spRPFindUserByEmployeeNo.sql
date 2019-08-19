USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPFindUserByEmployeeNo]    Script Date: 4/3/2019 1:07:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************
2018-12-01	Precious	PAT-012		select user details by employee number
 spRPFindUserByEmployeeNo 'pathprovider'
************************************************************************************/
CREATE PROCEDURE [dbo].[spRPFindUserByEmployeeNo] @username VARCHAR(20)
AS
BEGIN
	SELECT ROW_NUMBER() OVER( ORDER BY user_id,name,
			[username],
			[password],
			[email],
			locked,
			loginAttempts,
			isActive,name) AS id,
			user_id,
			name,
			[username],
			[password],
			[email],
			locked,
			loginAttempts,
			isActive,
			roles
FROM
		(SELECT		users.id user_id,
					users.name,
					[username],
					[password],
					[email],
					locked,
					loginAttempts,
						--COALESCE(NULLIF(loginAttempts,0),NULLIF([iNoOfAttempts],0),0) loginAttempts,
					isActive,
					--UPPER(SUBSTRING(groups.name,CHARINDEX('-', groups.name)+1,100)) roles
					groups.name roles
					--tbluser.bchangePassword changepassword
		FROM Framework.dbo.users (NOLOCK)
			INNER JOIN Framework.dbo.users_groups (NOLOCK) Usergroup ON(Usergroup.user_id=users.id)
			INNER JOIN Framework.dbo.groups (NOLOCK) ON(groups.id=Usergroup.group_id)
			--INNER JOIN dbUser.dbo.tblUser (NOLOCK) ON(CAST (tblUser.iId AS VARCHAR(30))=users.rId)
		WHERE username=@username
		AND groups.name LIKE 'pathprovider%'

		UNION

		SELECT  TOP 1 users.id user_id,
						users.name,
						[username],
						[password],
						[email],
						locked,
						loginAttempts,
						--COALESCE(NULLIF(loginAttempts,0),NULLIF([iNoOfAttempts],0),0) loginAttempts,
						isActive,
						'' roles
						--tbluser.bchangePassword changepassword
		FROM Framework.dbo.users (NOLOCK)
		--INNER JOIN dbUser.dbo.tblUser (NOLOCK) ON(CAST (tblUser.iId AS VARCHAR(30))=users.rId)

		WHERE username=@username AND NOT EXISTS (SELECT		users.id user_id
								FROM Framework.dbo.users (NOLOCK)
									INNER JOIN Framework.dbo.users_groups (NOLOCK) Usergroup ON(Usergroup.user_id=users.id)
									INNER JOIN Framework.dbo.groups (NOLOCK) ON(groups.id=Usergroup.group_id)
								--	INNER JOIN dbUser.dbo.tblUser (NOLOCK) ON(CAST (tblUser.iId AS VARCHAR(30))= users.rId)
							WHERE username=@username
							AND groups.name LIKE 'pathprovider%' )
		) AS tbl1

END