USE [ResultsPortal]
GO
IF OBJECT_ID('dbo.spReportResultLab') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportResultLab
	IF OBJECT_ID('dbo.spReportResultLab') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spReportHeader]    Script Date: 5/16/2019 2:55:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
10-01-2019	Precious	select results for single Lab report
--- zspReportResultLab  33693861,33693861,59715561,'LOUVP0','E'
-- spReportResultLab  9856115,33695202,59718078,'LOUVP0','E'
 @EFTCALC
******************************************************************************************************* */
CREATE PROCEDURE [dbo].[spReportResultLab]
										@patientId BIGINT,
										@requisitionId BIGINT ,
										@specimenId BIGINT,
										@DrMnemonic VARCHAR(15),
										@language CHAR(1)
										AS

BEGIN

	SET NOCOUNT ON
	DECLARE @reportConfidential CHAR(1),
			@recipient VARCHAR(15),
			@DocLanguage CHAR(1)

	SELECT @docLanguage=chLanguage
		FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId
																					AND DoctorRequisition.chInloadSystem=Doctor.chInloadSystem)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R'

	---check if doctor/ward can get confidentials.
	SELECT TOP 1 @reportConfidential=COALESCE(NULLIF(chReportConf,''),'N')
			FROM [DICT].[dbo].[tblDoctorType] (NOLOCK) DoctorType
					INNER JOIN RS.dbo.tblDoctor (NOLOCK) RSDoctor ON(RSDoctor.vchDoctorType=DoctorType.vchDoctorType)
					INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (RSDoctor.iId=DoctorRequisition.iDoctorId
																					AND DoctorRequisition.chReportType='R')
			WHERE DoctorRequisition.biRequisitionId=@requisitionId
				  AND DoctorType.chActive='Y'

SELECT DISTINCT
     COALESCE([HDR_ID] COLLATE DATABASE_DEFAULT,Result.[vchPrintNumberResult])AS Proc_ID,
	 COALESCE([HDR_Seq],'00') AS Proc_Seq1,
	 CASE WHEN  CONVERT(VARCHAR(2),Result.[iPrintOrder])='0' THEN Result.[vchPrintNumberResult] ELSE CONVERT(VARCHAR(2),Result.[iPrintOrder]) END AS Proc_Seq2,
	 Result.[vchPrintNumberResult]    AS Proc_Seq3,
	 CASE WHEN (@DocLanguage='A') THEN REPLACE(COALESCE([HDR_TXT_Afr],''),'*','') ELSE REPLACE(COALESCE([HDR_TXT_Eng],''),'*','') END  vchOrderTestName,
	 CASE WHEN (@DocLanguage='A') THEN TestInfo.vchReportNameAfr ELSE TestInfo.vchReportNameEng END  vchReportTestName,
	 Result.vchResult,
	 LTRIM(RTRIM(Result.vchAbnormalFlag))vchAbnormalFlag,
	 ISNULL(Result.vchNormalRange,'')+' '+ISNULL(Result.vchUnit,'')vchReference,
	 Result.vchPrintNumberResult,
	 Result.vchPrintNumberOrder,
	 COALESCE([dbo].[udfRSR_DeltaCheck] (Result.[biId]),'')  Delta,
	 ResultComment.vchComment Comment,
	 ResultCommentLink.siOrder,ResultCommentLink.chTag
FROM  [RS].[dbo].[tblResult]  (NOLOCK) Result
   INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info]  (NOLOCK) TestInfo
						  ON  TestInfo.[chInloadSystem]  =Result.[chInloadSystem]
						  AND TestInfo.[chDisciplineType]='LAB'
						  AND TestInfo.[vchPrintNumber]  =[vchPrintNumberResult]
						  AND TestInfo.[vchMethod]  =Result.[vchMethod]
	LEFT OUTER JOIN [RSReporting].[dbo].[tblRSR_Lab_Result_Headers] (NOLOCK) ResHeader
				ON ResHeader.LIS=Result.[chInloadSystem] COLLATE DATABASE_DEFAULT
				AND (ResHeader.[HDR_Set_ID]=[vchPrintNumberOrder]   COLLATE DATABASE_DEFAULT OR ResHeader.[HDR_Set_ID]=[vchPrintNumberResult] COLLATE DATABASE_DEFAULT)
				AND  ResHeader.[HDR_Item_ID]=[vchPrintNumberResult] COLLATE DATABASE_DEFAULT
				AND (CASE WHEN ResHeader.[HDR_Dup]='Y' THEN 'Y'
						  WHEN ResHeader.[HDR_ID]=(SELECT MIN(ResHeader2.[HDR_ID]) FROM [RSReporting].[dbo].[tblRSR_Lab_Result_Headers]  (NOLOCK) ResHeader2
												  WHERE ResHeader2.LIS=Result.[chInloadSystem]            COLLATE DATABASE_DEFAULT
												   AND ResHeader2.[HDR_Dup]='N'
                                       AND (ResHeader2.[HDR_Set_ID]=[vchPrintNumberOrder]   COLLATE DATABASE_DEFAULT OR ResHeader2.[HDR_Set_ID]=[vchPrintNumberResult] COLLATE DATABASE_DEFAULT)
                                       AND  ResHeader2.[HDR_Item_ID]=[vchPrintNumberResult] COLLATE DATABASE_DEFAULT) THEN 'Y' ELSE 'N' END)='Y'
	LEFT OUTER JOIN RS.dbo.tblResultCommentLink (NOLOCK)  ResultCommentLink ON (ResultCommentLink.biResultId = Result.biId)
	LEFT OUTER JOIN RS.dbo.tblResultComment (NOLOCK)  ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId
														AND	LTRIM(RTRIM(ResultComment.vchComment)) NOT LIKE '@%')
  WHERE Result.[biSpecimenId]=@specimenId
    AND COALESCE(TestInfo.[RptElecYN],'N')='Y'
    AND COALESCE(Result.vchResult,'') NOT IN ('ND','NP')
	AND (@reportConfidential='Y' OR TestInfo.chConfidential= 'N')
 ORDER BY Proc_ID,Proc_Seq1,Proc_Seq2,Proc_Seq3,chTag,siOrder

END


