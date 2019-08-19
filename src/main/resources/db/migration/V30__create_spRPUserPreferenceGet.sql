USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spRPUserPreferenceGet') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spRPUserPreferenceGet
	IF OBJECT_ID('dbo.spRPUserPreferenceGet') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END

GO

/****** Object:  StoredProcedure [dbo].[spRPUserPreferenceGet]    Script Date: 5/9/2019 10:15:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************
2018-02-01   Precious           Select user preferences
************************************************************************************/
CREATE PROCEDURE [dbo].[spRPUserPreferenceGet]
                                                                            @user_id VARCHAR(100)
AS
BEGIN
       SELECT  [iUser_id]
                                                 ,[chUserLanguage]
                                                 ,[iViewPeriod]
                                                 ,[vchTestProfile]
                                                 ,[vchViewStatus]
                                                 ,[chReportLayout]
                                                 ,[bCumulativeDirection]
                                                 ,[dtCreated]
                                                 ,[dtModified]

                                                              FROM tblUserPreferences
       WHERE iUser_id=@user_id
END