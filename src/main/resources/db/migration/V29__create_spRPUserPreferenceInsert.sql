USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spRPUserPreferenceInsert') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spRPUserPreferenceInsert
	IF OBJECT_ID('dbo.spRPUserPreferenceInsert') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spRPSpecimenList]    Script Date: 5/3/2019 1:06:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************
2018-02-01   Precious           Insert user preferences
************************************************************************************/
CREATE PROCEDURE [dbo].[spRPUserPreferenceInsert]
                                                                            @user_id VARCHAR(100)
                                                                           ,@userLanguage CHAR(1)
                                                                           ,@viewPeriod INT
                                                                           ,@viewStatus  VARCHAR(15)
                                                                           ,@reportLayout   CHAR(1)
                                                                           ,@cumulativeDirection INT
                                                                           ,@testProfile VARCHAR(30)

AS
BEGIN
  MERGE tblUserPreferences  AS newUserPreferences
  USING (SELECT iId FROM tblUserPreferences WHERE iUser_Id=@user_id) AS currentUserPreferences
  ON(newUserPreferences.iId=currentUserPreferences.iId)

  WHEN NOT MATCHED BY TARGET
             THEN INSERT (     [iUser_id]
                                                 ,[chUserLanguage]
                                                 ,[iViewPeriod]
                                                 ,[vchTestProfile]
                                                 ,[vchViewStatus]
                                                 ,[chReportLayout]
                                                 ,[bCumulativeDirection]
                                                 ,[dtCreated]
                                                 ,[dtModified])
                                               VALUES(@user_id,@userLanguage,@viewPeriod,@testProfile,@viewStatus,@reportLayout,@cumulativeDirection,GETDATE(),GETDATE())
  WHEN  MATCHED
             THEN UPDATE SET iUser_id=@user_id,chUserLanguage=@userLanguage,iViewPeriod=@viewPeriod,vchTestProfile=@testProfile,vchViewStatus=@viewStatus,chReportLayout=@reportLayout,bCumulativeDirection=@cumulativeDirection
                                                            ,dtModified=GETDATE();
END
