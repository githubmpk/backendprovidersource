USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPUserLoginUpdate]    Script Date: 4/3/2019 10:51:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************
2018-12-01    Precious      PAT-012              update user details after login
spRPFindUserByEmployeeNo 'preciousa'
************************************************************************************/
CREATE PROCEDURE [dbo].[spRPUserLoginUpdate]
                                                       @username VARCHAR(20),
                                                       @loginStatus VARCHAR(20)
AS
BEGIN

       UPDATE Framework.dbo.users
                     SET loginAttempts= CASE WHEN @loginStatus='FAILED' THEN loginAttempts+1 ELSE 0 END,
                           locked=CASE WHEN @loginStatus='FAILED' AND loginAttempts+1 > 3 THEN 1 ELSE 0 END,
                           lastLogin=GETDATE()
       FROM Framework.dbo.users (NOLOCK)
       WHERE username=@username
END