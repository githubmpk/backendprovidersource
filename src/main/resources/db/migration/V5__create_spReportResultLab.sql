USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultLab]    Script Date: 4/3/2019 10:43:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
			@reportApath CHAR(1),
			@recipient VARCHAR(15)

	--find requesting doctor if no doctor sepecified
	SELECT TOP 1 @recipient = CASE WHEN @DrMnemonic='' THEN  Doctor.vchDoctorMnemonic ELSE @DrMnemonic END
		FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId)
	WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R'


	SELECT TOP 1 @reportConfidential=COALESCE(NULLIF(chReportConf,''),'N'),@reportApath=COALESCE(NULLIF(chReportApath,''),'N')
			FROM [DICT].[dbo].[tblDoctorType] (NOLOCK) DoctorType
			INNER JOIN  [DICT].[dbo].[tblDoctor] (NOLOCK) Doctor ON(Doctor.vchDoctorType=DoctorType.vchDoctorType
																	AND Doctor.iSystemId=DoctorType.iSystemId
																	AND Doctor.chInloadSystem=DoctorType.chInloadSystem
																	)
			WHERE Doctor.vchDoctorMnemonic=@recipient
				  AND DoctorType.chActive='Y'
				  --AND DoctorType.chReportConf <>''  ---check if doctor/ward can get confidentials.

	SELECT vchReportTestName = CASE WHEN (@language='A') AND TestReportDetail.vchReportNameAfr IN ('-','.') THEN REPLACE(TestResult.vchOrderNameAfr,'*','')
								 WHEN (@language='A') AND TestReportDetail.vchReportNameAfr NOT IN ('-','.') THEN REPLACE(TestReportDetail.vchReportNameAfr,'*','')
								 WHEN (@language='E') AND TestReportDetail.vchReportNameEng IN ('-','.') THEN REPLACE(TestResult.vchOrderNameEng,'*','')
							     ELSE REPLACE(TestReportDetail.vchReportNameEng,'*','') END,
			Result.vchResult,
			LTRIM(RTRIM(Result.vchAbnormalFlag))vchAbnormalFlag,
			ISNULL(Result.vchNormalRange,'')+' '+ISNULL(Result.vchUnit,'')vchReference,
			ResultComment.vchComment Comment,
			Result.vchPrintNumberResult,
			Result.vchPrintNumberOrder,
			vchOrderTestName =CASE WHEN TestCumulativeOrder.tiSortOrder < 10 THEN 'SAMPLE APPEARANCE'
							   WHEN(@language='A')THEN REPLACE(TestOrder.vchOrderNameAfr,'*','')
								    ELSE REPLACE(TestOrder.vchOrderNameEng,'*','') END,
			TestResult.chConfidential, @specimenId specimenId,
			Specimen.vchDepartment department
	FROM RS.dbo.tblResult (NOLOCK)  Result
		INNER JOIN RS.dbo.tblSpecimen (NOLOCK)  Specimen ON (Specimen.biId = Result.biSpecimenId)
		LEFT OUTER JOIN RS.dbo.tblTestReportDetail  (NOLOCK)  TestReportDetail ON (TestReportDetail.vchPrintNumber = Result.vchPrintNumberResult
																			AND TestReportDetail.chInloadSystem = Result.chInloadSystem
																			AND TestReportDetail.vchMethod = Result.vchMethod)
		LEFT OUTER JOIN RS.dbo.tblResultCommentLink (NOLOCK)  ResultCommentLink ON (ResultCommentLink.biResultId = Result.biId)
		LEFT OUTER JOIN RS.dbo.tblResultComment (NOLOCK)  ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId
															AND ResultComment.vchComment NOT LIKE '@%')
		LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK)  TestOrder ON (TestOrder.vchPrintNumber = Result.vchPrintNumberOrder
														AND TestOrder.chInloadSystem = Result.chInloadSystem
														AND TestOrder.chDisciplineType = Specimen.chDisciplineType)
		LEFT OUTER  JOIN  RS.dbo.tblTest (NOLOCK)  TestResult ON (TestResult.vchPrintNumber = Result.vchPrintNumberResult
												 AND TestResult.chInloadSystem = Result.chInloadSystem
												 AND TestResult.chDisciplineType = Specimen.chDisciplineType)
		LEFT OUTER  JOIN  RS.dbo.tblTestCumulativeOrder (NOLOCK) TestCumulativeOrder  ON (TestCumulativeOrder.vchProfileName = TestResult.vchProfileName)
		LEFT OUTER JOIN (	SELECT		OrdTest,
										ResTest,
										ResHdr_Sys,
										MIN(TRY_CONVERT(NUMERIC(18,6),HdrSeq1))	[HdrSeq1],
										MIN(TRY_CONVERT(NUMERIC(18,6),HdrSeq2)) [HdrSeq2],
										MIN(TRY_CONVERT(NUMERIC(18,6),HdrSeq3)) [HdrSeq3],
										MIN(TRY_CONVERT(NUMERIC,ListSeq))		[ListSeq]
								FROM		RSReporting.dbo.tblRSR_PCXML_Result_Headers (NOLOCK)
								GROUP BY	OrdTest, ResTest, ResHdr_Sys
			) AS Headers ON (Result.vchPrintNumberOrder=Headers.OrdTest COLLATE DATABASE_DEFAULT
								AND Result.vchPrintNumberResult=Headers.ResTest COLLATE DATABASE_DEFAULT
								AND Result.chInloadSystem=Headers.ResHdr_Sys COLLATE DATABASE_DEFAULT )

	WHERE  Result.biSpecimenId = @specimenId
			AND COALESCE(Result.vchResult, 'PRINT') <> 'NP'
			AND COALESCE(TestResult.chReportable,'N')  =  'Y'
			AND Specimen.chDisciplineType='LAB'
			--AND TestResult.chConfidential=CASE WHEN @reportConfidential='N'
			--								THEN 'N'  ELSE  TestResult.chConfidential END
			AND (@reportConfidential='Y' OR TestResult.chConfidential= 'N')

	ORDER BY COALESCE([HdrSeq1],'0'),
			 COALESCE([HdrSeq2],'0'),
			 COALESCE([HdrSeq3],[vchPrintNumberOrder]),
			 [vchPrintNumberOrder],
			 [vchPrintNumberResult],siOrder
END