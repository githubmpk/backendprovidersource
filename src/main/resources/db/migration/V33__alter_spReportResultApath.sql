USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spReportResultApath') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportResultApath
	IF OBJECT_ID('dbo.spReportResultApath') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
/****** Object:  StoredProcedure [dbo].[spReportResultApath]    Script Date: 5/16/2019 3:10:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
Created by:		Precious
Create date:	2019-01-10
Details:		Select results for Apath report
Reference		Date		Author			Description
******************************************************************************************************* */
CREATE PROCEDURE [dbo].[spReportResultApath] @patientId BIGINT,
											@specimenId BIGINT,
											@language CHAR(1) AS
BEGIN
	SET NOCOUNT ON

	SELECT DISTINCT
					RIGHT('000'+CONVERT(VARCHAR(3),Result.[iPrintOrder]),3) [Proc_ID]
					,RIGHT('000'+CONVERT(VARCHAR(3),Result.[iPrintOrder]),3) [Item_Seq1]
					,'0' [Item_Seq2]
					,RIGHT('000'+CONVERT(VARCHAR(3),Result.[iPrintOrder]),3) [Item_Seq3]
					,T.[vchApathTestMnemonic] [Proc_Code]
					,[vchApathTestLoinc]      [Item_Loinc]
					,T.[vchApathTestMnemonic] [Item_Code]
					,REPLACE(T.[vchApathTestName],'*','') vchPrintNumberResult
					--,COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments] (Result.[biId]),'') vchComment
					,NULLIF(ResultComment.vchComment,'') + ' ' + COALESCE(ICD10.vchDescription,'') vchComment
					,ResultCommentLink.siOrder
					,ResultCommentLink.chTag

FROM  [RS].[dbo].[tblResult] Result (NOLOCK)

		INNER JOIN RS.dbo.tblApathOrderTest O (NOLOCK)	ON (O.[chInloadSystem]=Result.[chInloadSystem]
															AND O.[vchOrderMnemonic]=Result.[vchPrintNumberOrder])

		INNER JOIN RS.dbo.tblApathTest T (NOLOCK) ON (T.[chInloadSystem]=Result.[chInloadSystem]
														AND T.[vchApathTestMnemonic]=O.[vchResultMnemonic]
														AND T.vchApathTestName=vchPrintNumberResult)

		INNER JOIN [RS].[dbo].[tblApathTestProcedure] P (NOLOCK) ON (P.[chInloadSystem]=Result.[chInloadSystem]
																		AND P.[vchApathTestMnemonic]=O.[vchOrderMnemonic])
		LEFT OUTER JOIN RS.dbo.tblResultCommentLink (NOLOCK)  ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
		LEFT OUTER JOIN RS.dbo.tblResultComment (NOLOCK)  ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
		LEFT OUTER JOIN	RS.dbo.tblICD10 (NOLOCK)  ICD10 On (ICD10.vchCode = ResultComment.vchComment)

WHERE Result.biSpecimenId = @specimenId
	AND iPrintOrder<>999 and vchComment NOT LIKE '@%'
ORDER BY Item_Seq1,Item_Seq2,Item_Seq3, ResultCommentLink.chTag, ResultCommentLink.siOrder

END