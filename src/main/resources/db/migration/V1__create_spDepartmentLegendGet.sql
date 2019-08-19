                      USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spDepartmentLegendGet]    Script Date: 4/3/2019 10:38:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:           John Murray
-- Create date: 2019/03/01 08h50
-- Description:      Select all display-able departments for showing the legend with colours scheme.
-- =============================================
CREATE PROCEDURE [dbo].[spDepartmentLegendGet]

AS
BEGIN

SELECT [chDepartmentCode]
      ,[chDisciplineType]
      ,[vchNameAfr]
      ,[vchNameEng]
      ,[vchForeground]
      ,[vchBackground]
      ,[chAbbreviationEng]
      ,[vchLongTextEng]
      ,[vchShortTextEng]
      ,[biLegendDisplay]
      ,[vchLongTextAfr]
      ,[vchShortTextAfr]
      ,[chAbbreviationAfr]

  FROM [RS].[dbo].[tblDepartment]

  WHERE [RS].[dbo].[tblDepartment].biLegendDisplay = 1


END