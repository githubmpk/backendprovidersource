USE [ResultsPortal]
GO
IF OBJECT_ID('dbo.spRPPatientListGet') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spRPPatientListGet
	IF OBJECT_ID('dbo.spRPPatientListGet') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spReportHeader]    Script Date: 5/16/2019 2:55:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
2018-12-20	 Precious		Select a list of patients for the specified parameters.
spRPPatientListGet 0,'','','','','5506155212088','','','','','2018-01-01','2019-01-01'
spRPPatientListGet 0,'KINCICU','','','','','','','','','2018-12-19','2019-01-19'
**********************************************************************************************/
CREATE PROCEDURE  [dbo].[spRPPatientListGet]
					@iProviderId INTEGER,
					@doctorMnemonic VARCHAR(10),
					@vchList VARCHAR(100)='1|0',
					@vchPatFirstName VARCHAR(20),
					@vchPatSurname VARCHAR(20),
					@vchPatID VARCHAR(20),
					@dPatDOB DATE,
					@vchRequisitionNumber VARCHAR(20),
					@vchProfileList VARCHAR(100),
					@vchDepartment VARCHAR(10),
					@dStart DATE,
					@dEnd DATE
AS

BEGIN
	SET NOCOUNT ON
	DECLARE	@tiLevel TINYINT,
			@tiProfileApply TINYINT,
			@iProfileKeyId INTEGER,
			@chDepartmentCode CHAR(1),
			@chDisciplineType VARCHAR(3),
			@vchSQL NVARCHAR(MAX),
			@recipient VARCHAR(15),
			@reportConfidential CHAR(1),
			@reportApath CHAR(1)

	SELECT	@vchDepartment=CASE WHEN @vchDepartment='' THEN '*|*' ELSE @vchDepartment END,
			@vchProfileList= CASE WHEN @vchProfileList= 0 THEN '' ELSE @vchProfileList END,
	      	@chDepartmentCode = LEFT(@vchDepartment,1),
			@chDisciplineType = SUBSTRING(@vchDepartment,3,3),
			@dEnd = DATEADD(d, 1, @dEnd),
			@tiLevel = LEFT(@vchList,1),
			@vchList = SUBSTRING(@vchList, 3, 97)




	SELECT TOP 1 @reportConfidential=CASE WHEN @doctorMnemonic='' THEN 'Y' ELSE COALESCE(NULLIF(chReportConf,''),'N') END,
			 	@reportApath=CASE WHEN @doctorMnemonic='' THEN 'Y' ELSE COALESCE(NULLIF(chReportApath,''),'N')  END
			FROM [DICT].[dbo].[tblDoctorType] (NOLOCK) DoctorType
			INNER JOIN  [RS].[dbo].[tblDoctor] (NOLOCK) Doctor ON(Doctor.vchDoctorType=DoctorType.vchDoctorType
																	--AND Doctor.iSystemId=DoctorType.iSystemId
																	AND Doctor.chInloadSystem=DoctorType.chInloadSystem
																	)
			WHERE (@doctorMnemonic='' OR Doctor.vchDoctorMnemonic=@doctorMnemonic)
				  AND DoctorType.chActive='Y'

	;WITH ResultsCTE AS
		(SELECT ROW_NUMBER() OVER (ORDER BY tbl1.vchPatName) AS iRowId,
					COUNT(*) OVER() AS TRowCount,*
		FROM  (
				 SELECT  DISTINCT
					PatientA.vchPatSurname+' ' +PatientA.vchPatFirstname  vchPatName,
					PatientA.biId biPatientId,
					CASE WHEN	   PatientA.dPatDOB IS NULL OR PatientA.dPatDOB = '1900-01-01' THEN ''
										ELSE CONVERT(VARCHAR(10),PatientA.dPatDOB,120) END dPatDOB,
					PatientA.chPatGender,
					PatientA.vchPatID,
					PatientA.vchPatSurname,
					PatientA.biPatientId iPatientParentId,
					PatientA.vchPatFirstname,
					--PatientA.vchPatEmail,
					PatientA.tiLink
		FROM RS.dbo.tblPatient (NOLOCK)  Patient
			INNER JOIN RS.dbo.tblPatient (NOLOCK) PatientA  ON (Patient.biPatientId = PatientA.bIId)
			INNER JOIN RS.dbo.tblRequisition (NOLOCK) Requisition  ON ( Requisition.vchRequisitionUrn NOT LIKE '%J'
																		AND	Requisition.biPatientId = Patient.biId
																		AND (@vchRequisitionNumber=''
																					AND (Requisition.dtCollection >=  CONVERT( VARCHAR(16),@dStart , 20)
																					AND Requisition.dtCollection <= CONVERT( VARCHAR(16),@dEnd , 20))
																				OR Requisition.vchRequisitionNumber = @vchRequisitionNumber
																		     )
																		)

			INNER JOIN RS.dbo.tblSpecimen (NOLOCK)  Specimen  ON (Specimen.biRequisitionId = Requisition.biId
																	AND Specimen.chDepartmentCode = CASE WHEN  @chDepartmentCode ='*' THEN Specimen.chDepartmentCode
																							ELSE @chDepartmentCode END
																	AND Specimen.chDisciplineType = CASE WHEN  @chDisciplineType= '*' THEN Specimen.chDisciplineType
																							ELSE @chDisciplineType END
																	AND Specimen.vchStatus <>'CAN')
			INNER JOIN RS.dbo.tblResult (NOLOCK)  Result  ON (Result.biSpecimenId=Specimen.biId)
			LEFT OUTER  JOIN  RS.dbo.tblTest (NOLOCK)  TestResult ON (TestResult.vchPrintNumber = Result.vchPrintNumberResult
																		 AND TestResult.chInloadSystem = Result.chInloadSystem
																		 AND TestResult.chDisciplineType = Specimen.chDisciplineType)
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition   ON (DoctorRequisition.biRequisitionId = Requisition.biId)
			INNER JOIN RS.dbo.tblDoctor (NOLOCK) Doctor  ON (Doctor.iId = DoctorRequisition.iDoctorId)
			LEFT OUTER JOIN RS.dbo.tblProviderTestProfile (NOLOCK) ProviderTestProfile  ON (ProviderTestProfile.vchPrintNumber = Result.vchPrintNumberResult
																							AND ProviderTestProfile.chDisciplineType = Specimen.chDisciplineType
																							AND ProviderTestProfile.iProviderId = @vchProfileList)


	  WHERE  COALESCE(ProviderTestProfile.vchPrintNumber,'*' ) = CASE WHEN @vchProfileList<>'' THEN COALESCE(ProviderTestProfile.vchPrintNumber,'@')
																ELSE COALESCE(ProviderTestProfile.vchPrintNumber,'*') END
	  	    AND
			(@doctorMnemonic='' OR Doctor.vchDoctorMnemonic =  @doctorMnemonic)
			AND( @vchPatID='' OR Patient.vchPatID = @vchPatID)
			AND ( @vchPatSurname ='' OR  Patient.vchPatSurname LIKE @vchPatSurname+'%')
			AND  (@vchPatFirstName='' OR Patient.vchPatFirstName LIKE @vchPatFirstName+'%')
	        AND (@dPatDOB='' OR Patient.dPatDOB =@dPatDOB)
			AND (@reportConfidential='Y' OR TestResult.chConfidential= 'N')
			AND (@reportApath='Y' OR Specimen.chDisciplineType <> 'PTH')
 ) AS tbl1 )

	SELECT *
		FROM ResultsCTE
	 ORDER BY iRowId
		OPTION(RECOMPILE)

END