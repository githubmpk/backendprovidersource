USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.udfReportResultsMicroComment') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udfReportResultsMicroComment
	IF OBJECT_ID('dbo.udfReportResultsMicroComment') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  UserDefinedFunction [dbo].[udfReportResultsMicroComment]    Script Date: 5/22/2019 10:27:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************************
Created by:		PvNiekerk
Create date:	2019-05-15
Details:		Return Micro specific comments for report (using function created by RM).
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2019-05-15	PvNiekerk		Create
******************************************************************************************************************************/
CREATE FUNCTION [dbo].[udfReportResultsMicroComment] (@SpcID BIGINT)
RETURNS

 @Comments TABLE(
	[Res_Type] [varchar](1) NOT NULL,
	[Sort_Seq1] [varchar](64) NOT NULL,
	[Sort_Seq2] [varchar](64) NOT NULL,
	[Res_Seq] [varchar](3) NULL,
	[Test_Set_ID] [varchar](20) NOT NULL,
	[Test_Item_ID] [varchar](40) NOT NULL,
	[Res_ItmID] [varchar](32) NOT NULL,
	[Res_Item_Code] [varchar](20) NOT NULL,
	[Comment] [varchar](max) NULL
	)
AS

BEGIN

INSERT INTO @Comments
SELECT * FROM [RSReporting].[dbo].[udfRSR_Mic_Get_Comments] (@SpcID)

RETURN
END

