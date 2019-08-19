USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spReportResultMicro') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportResultMicro
	IF OBJECT_ID('dbo.spReportResultMicro') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO


/****** Object:  StoredProcedure [dbo].[spReportResultMicro]    Script Date: 5/22/2019 10:49:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************************
Created by:		PvNiekerk
Create date:	2019-04-01
Details:		Micro results based on function originally created by RM.
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2019-04-01	PvNiekerk		Create
******************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spReportResultMicro]
--declare
@specimenId BIGINT,
@language CHAR(1)

AS

--set @specimenId = 57344832 --57117119 --57117119 --48084368
--set @language = 'E'

;WITH cte
AS
(
SELECT
	*
FROM
	[dbo].[udfReportResultsMicro] (@specimenId)
),
data AS
(
SELECT
	Res_Type,
	Sort_Seq1,
	Sort_Seq2,
	Res_Seq,
	Test_Set_ID,
	Test_Set_Code,
	Test_Method,
	Test_Set_Abbrv_Afr,
	Test_Set_Abbrv_Eng,
	Test_Set_Loinc,
	Test_Set_Afr,
	Test_Set_Eng,
	Test_Item_ID,
	Test_Item_Code,
	Test_Item_Abbrv_Afr,
	Test_Item_Abbrv_Eng,
	Test_Item_Loinc,
	Test_Item_Afr,
	Test_Item_Eng,
	Add_ID,
	Add_Code,
	Add_Group,
	Add_SubGroup,
	Res_Loinc,
	Res_ItmID,
	Res_Item_Code,
	Res_Item_Abbrv,
	--Res_Item,
	Res_Item = CASE Res_Type
					WHEN 3 THEN
						CASE
							WHEN LEN(Res_Item_Code) = 0 THEN ' ' + CASE
																	WHEN CHARINDEX('  *:', LTRIM(RTRIM(Res_Item))) <> 0 THEN ' ' + REPLACE(LTRIM(RTRIM(Res_Item)), '  *:', '*:')
																	WHEN CHARINDEX('  :', LTRIM(RTRIM(Res_Item))) <> 0 THEN ' ' + REPLACE(LTRIM(RTRIM(Res_Item)), '  :', ':')
																	ELSE LTRIM(RTRIM(Res_Item))
																END

							ELSE Res_Item
						END
					ELSE Res_Item
	END,
	Res_Code,
	Result,
	Units,
	NormalRange,
	AbnFlag,
	tiSpecialResult
FROM
	cte
)
SELECT
	*
FROM
	data
ORDER BY
	Test_Item_ID,
	Sort_Seq1,
	Sort_Seq2,
	Res_Seq
