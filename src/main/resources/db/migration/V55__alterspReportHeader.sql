USE [ResultsPortal]
GO
IF OBJECT_ID('dbo.spReportHeader') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportHeader
	IF OBJECT_ID('dbo.spReportHeader') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spReportHeader]    Script Date: 5/16/2019 2:55:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
Created by:		Precious
Create date:	2019-01-10
Details:		select data for single report header
Reference		Date		Author			Description
--------------------------------------------------------------------------------------------------------
******************************************************************************************************* */
 CREATE PROCEDURE  [dbo].[spReportHeader]  @patientId INTEGER,
									@requisitionId INTEGER,
									@specimenId INTEGER,
									@DrMnemonic VARCHAR(20),
									@language CHAR(1)
AS
BEGIN
	DECLARE @docLanguage CHAR(1),
			@captionType VARCHAR(20),
			@ReqAge VARCHAR(4)

	SELECT  TOP 1 @docLanguage=Doctor.chLanguage,
				@captionType = COALESCE(NULLIF(vchReportFields,''),'standard'),
				@ReqAge=CASE WHEN CONVERT(VARCHAR(10),Requisition.dtCollection,120)<> CONVERT(VARCHAR(10),Requisition.dtEntered,120)
					 THEN LEFT(Requisition.vchAge, 3)+1 ELSE LEFT(Requisition.vchAge, 3) END
		FROM RS.dbo.tblDoctor (NOLOCK) Doctor			LEFT OUTER JOIN DICT.dbo.tblDoctorType (NOLOCK)  dictDoctorType ON(Doctor.vchDoctorType=dictDoctorType.vchDoctorType
																				AND Doctor.chInloadSystem=dictDoctorType.chInloadSystem)
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId
																				AND Doctor.chInloadSystem=DoctorRequisition.chInloadSystem)
		    INNER JOIN RS.dbo.tblRequisition (NOLOCK)  requisition  ON(requisition.biId=DoctorRequisition.biRequisitionId
																		AND requisition.chInloadSystem = DoctorRequisition.chInloadSystem)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R'

	;WITH RecipientCTE AS
	(SELECT DISTINCT Doctor.iId iDoctorId,
					 Doctor.chLanguage,
					 dictDoctor.vchNameTitle vchName,
					 Doctor.vchStreetAddress1,
					 Doctor.vchStreetAddress2,
					 Doctor.vchDoctorMnemonic,
			LTRIM(ISNULL(REPLACE(Doctor.vchStreetPostalCode,'XXXX',''),'')+ ' ' + ISNULL(Doctor.vchStreetCity,'')) vchDrAddressCityCode,
			Doctor.vchDoctorType
	FROM RS.dbo.tblDoctor (NOLOCK) Doctor
		INNER JOIN DICT.dbo.tblDoctor (NOLOCK)  dictDoctor ON(dictDoctor.vchDoctorMnemonic=Doctor.vchDoctorMnemonic
																AND dictDoctor.chInloadSystem=Doctor.chInloadSystem)
		WHERE (@DrMnemonic<>'' AND Doctor.vchDoctorMnemonic=@DrMnemonic)
			   --AND Doctor.chActive='Y'
	UNION

	SELECT DISTINCT  Doctor.iId iDoctorId,
					 Doctor.chLanguage,
					 dictDoctor.vchNameTitle vchName,
					 Doctor.vchStreetAddress1,
					 Doctor.vchStreetAddress2,
					 Doctor.vchDoctorMnemonic,
					 LTRIM(ISNULL(REPLACE(Doctor.vchStreetPostalCode,'XXXX',''),'')+ ' ' + ISNULL(Doctor.vchStreetCity,'')) vchDrAddressCityCode,
					 Doctor.vchDoctorType
	FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId
																				  AND DoctorRequisition.chInloadSystem=Doctor.chInloadSystem)
			INNER JOIN DICT.dbo.tblDoctor (NOLOCK)  dictDoctor ON(dictDoctor.vchDoctorMnemonic=Doctor.vchDoctorMnemonic
																	AND dictDoctor.chInloadSystem=Doctor.chInloadSystem)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R' AND @DrMnemonic=''
				AND DoctorRequisition.chInloadSystem=Doctor.chInloadSystem
	),
	OrderedTestCTE AS(SELECT DISTINCT TestOrder.vchPrintNumber,
									CASE WHEN   @docLanguage='A' THEN LTRIM(RTRIM(REPLACE(TestOrder.vchAbbreviatedNameAfr,'*',''))) ELSE LTRIM(RTRIM(REPLACE(TestOrder.vchAbbreviatedNameEng,'*',''))) END  vchOrderNameEng
						  FROM  RS.dbo.tblSpecimen (NOLOCK) Specimen
								INNER JOIN  RS.dbo.tblResult (NOLOCK)  Result ON(Result.biSpecimenId=Specimen.biId)
								LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK)  TestOrder ON ( TestOrder.vchPrintNumber=Result.vchPrintNumberOrder AND
																						TestOrder.chInloadSystem=Result.chInloadSystem
																						AND TestOrder.chDisciplineType = Specimen.chDisciplineType)
								WHERE Specimen.birequisitionId=@requisitionId
								--Specimen.vchStatus<>'CAN'
									AND LEFT(TestOrder.vchAbbreviatedNameEng,1)<>'~'  -- sign out tests must not appear on the report
								),
	specimenCommentCTE AS(SELECT DISTINCT  SpecimenComment.vchComment specimenComment, siOrder
								FROM RS.dbo.tblSpecimenCommentLink (NOLOCK)  SpecimenCommentLink
									INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK)  SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId)
									INNER JOIN RS.dbo.tblSpecimen  (NOLOCK)  specimen ON (specimen.biId=SpecimenCommentLink.biSpecimenId)
							WHERE
							SpecimenCommentLink.chTag NOT IN('H','Z')
							AND NULLIF(SpecimenComment.vchComment,'') IS NOT NULL
							AND SpecimenComment.vchComment NOT LIKE '@%'
							AND NULLIF(specimen.vchDepartment,'') IS NOT NULL
							AND specimen.biId=@specimenId
							),
		DoctorsCTE AS(SELECT dictDoctor.vchNameTitle vchName,chReportType
							FROM RS.dbo.tblDoctor (NOLOCK) Doctor
							INNER JOIN  RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (DoctorRequisition.iDoctorId = Doctor.iId
																									AND DoctorRequisition.chInloadSystem=Doctor.chInloadSystem)
							INNER JOIN DICT.dbo.tblDoctor (NOLOCK)  dictDoctor ON(dictDoctor.vchDoctorMnemonic=Doctor.vchDoctorMnemonic
																					AND dictDoctor.chInloadSystem=Doctor.chInloadSystem)
							WHERE DoctorRequisition.biRequisitionId=@requisitionId
									)

	 SELECT TOP 1 Patient.bipatientId, Patient.biId, LTRIM(ISNULL(Patient.vchPatTitle,'')+ ' '+ ISNULL(patient.vchPatFirstName,'')+' '+ ISNULL(patient.vchPatSurname,'')) vchPatName,
						CASE  WHEN Patient.chPatGender = 'U' THEN ''
								WHEN @docLanguage = 'A' and Patient.chPatGender = 'F' THEN 'V'
							 ELSE Patient.chPatGender END  chPatGender,
						CASE WHEN  ISNULL(Patient.vchGuarPhoneMobile,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE', '') THEN Patient.vchGuarPhoneMobile
							 WHEN  ISNULL(Patient.vchGuarPhoneMobile,'')  IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE', '')
								 AND ISNULL(Patient.vchGuarPhoneHome,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','') THEN Patient.vchGuarPhoneHome
							 WHEN ISNULL(Patient.vchGuarPhoneMobile,'') IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','')
								  AND ISNULL(Patient.vchGuarPhoneHome,'') IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','')
								  AND ISNULL(Patient.vchGuarPhoneWork,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','') THEN Patient.vchGuarPhoneWork
									 ELSE  'N/A'  END  vchGuarPhoneMobile,

						CASE WHEN ISNULL(Patient.vchPatPhoneMobile,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','') THEN Patient.vchPatPhoneMobile
							 WHEN ISNULL(Patient.vchPatPhoneMobile,'') IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','')
								  AND ISNULL(Patient.vchPatPhoneHome,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','') THEN Patient.vchPatPhoneHome
							 WHEN ISNULL(Patient.vchPatPhoneMobile,'') IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','')
								  AND ISNULL(Patient.vchPatPhoneHome,'') IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','')
								  AND ISNULL(Patient.vchPatPhoneWork,'') NOT IN ('NOT AVAILABLE', 'NIE BESKIKBAAR NIE','') THEN Patient.vchPatPhoneWork
										 ELSE  'N/A'  END  vchPatPhoneMobile,

						CASE WHEN	   Patient.dPatDOB IS NULL OR Patient.dPatDOB = '1900-01-01' THEN ''
										 ELSE CONVERT(VARCHAR(10),Patient.dPatDOB,120) END dPatDOB,

						CASE WHEN LEFT(Requisition.vchAge, 4) = '000y' THEN ''
									WHEN LEFT(Requisition.vchAge, 2) = '00' THEN SUBSTRING(Requisition.vchAge,3,2)
									WHEN LEFT(Requisition.vchAge, 1) = '0' THEN SUBSTRING(Requisition.vchAge,2,3)
									WHEN @captionType='vet' THEN Title.vchTitle
									ELSE LEFT(Requisition.vchAge, 4) END +''+
						CASE WHEN SUBSTRING(Requisition.vchAge, 6, 4) = '000m' THEN ''
									WHEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),1,2) = '00' THEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),3,2)
									WHEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),1,1) = '0' THEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),2,3)
									WHEN @captionType='vet' THEN ''
									ELSE SUBSTRING(Requisition.vchAge, 6, 4) END + ''+
						CASE WHEN RIGHT(Requisition.vchAge, 4) = '000d' THEN ''
									WHEN SUBSTRING(RIGHT(Requisition.vchAge, 4),1,2) = '00' THEN SUBSTRING(RIGHT(Requisition.vchAge, 4),3,2)
									WHEN SUBSTRING(RIGHT(Requisition.vchAge, 4),1,1) = '0' THEN SUBSTRING(RIGHT(Requisition.vchAge, 4),2,3)
									WHEN @captionType='vet' THEN ''
									ELSE RIGHT(Requisition.vchAge,4) END
									+ ': ' + Patient.chPatGender
									+ CASE WHEN	Patient.dPatDOB IS NULL OR Patient.dPatDOB = '1900-01-01' THEN ''
										 ELSE + ': ' + CONVERT(VARCHAR(10),Patient.dPatDOB,120) END ageGenderPatDOB,

						CASE WHEN  Patient.vchPatID IN  ('NOT AVAILABLE','NIE BESKIKBAAR NIE', '')
													THEN 'N/A'
						ELSE Patient.vchPatID END vchPatID,
						LTRIM(ISNULL(Patient.vchGuarTitle,'')+' '+ ISNULL(patient.vchGuarFirstName,'') +' '+ ISNULL(patient.vchGuarSurname,'')) vchGuarName,
						COALESCE(REPLACE(Patient.vchMedicalAid,'  ',' '),'Unknown') vchMedicalAid,
						Patient.vchMedicalAidNumber,
						REPLACE(RecipientCTE.vchName,'  ',' ') vchDrName,
						RecipientCTE.vchStreetAddress1 vchDrAddress1,
						RecipientCTE.vchStreetAddress2 vchDrAddress2,
						RTRIM(LTRIM(RecipientCTE.vchDrAddressCityCode)) vchDrAddressCityCode,
						RecipientCTE.chLanguage,
						Patient.chInloadSystem,vchDoctorType,
						REPLACE(STUFF((SELECT
									'; ' + vchOrderNameEng  AS [data()]
							FROM  OrderedTestCTE
							ORDER BY vchPrintNumber
							FOR XML PATH (''),ROOT('test'),TYPE
							).value('/test[1]','VARCHAR(MAX)'),1,2,''),' ;',';')
						AS orderedTest,


					CASE WHEN @docLanguage = 'A'  AND DATEPART(ss, Requisition.dtCollection) = 11
								THEN CONVERT(VARCHAR(10),Requisition.dtCollection,105) + ' UNK'
						 WHEN @docLanguage = 'E'  AND DATEPART(ss, Requisition.dtCollection) = 11
								THEN CONVERT(VARCHAR(10),Requisition.dtCollection,105) + ' UNK'
						 ELSE CONVERT(VARCHAR(16),Requisition.dtCollection,120) END CollectionDate,
					vchRequisitionNumber AS RequisitionNumber,

					CASE WHEN @docLanguage = 'A'  AND DATEPART(ss, Requisition.dtReceived) = 11
								THEN CONVERT(VARCHAR(10),Requisition.dtReceived,105) + ' UNK'
						 WHEN @docLanguage = 'E'  AND DATEPART(ss, Requisition.dtReceived) = 11
								THEN CONVERT(VARCHAR(10),Requisition.dtReceived,105) + ' UNK'
						WHEN Requisition.dtReceived IS NULL OR Requisition.dtReceived = '1900-01-01 00:00' THEN ''
						 ELSE CONVERT(VARCHAR(16),Requisition.dtReceived,120) END recievedDate,
					CONVERT(VARCHAR(16),specimen.dtInloadUpdate,121)  AS reportDate,
     				REPLACE( STUFF((SELECT DISTINCT '; ' + LTRIM(RTRIM(REPLACE(COALESCE(vchName,''),'  ',' ')))  AS [data()]
						FROM DoctorsCTE WHERE chReportType='C'
						FOR XML PATH (''),ROOT('Doctor'),TYPE
							).value('/Doctor[1]','VARCHAR(MAX)'),1,2,''),' ;',';')
					    AS vchNameCopyDr,
     				(SELECT vchName
							FROM DoctorsCTE WHERE chReportType='R'
							) AS refDoctor,
					specimen.vchSpecimenNumber specimenNumber,
					CASE WHEN  @docLanguage='A' THEN department.vchNameAfr ELSE department.vchNameEng END vchDepartment,
					ISNULL(requisition.vchICD10List,'') ICD10List,
   					REPLACE(STUFF((SELECT
									';' + specimenComment AS [data()]
							FROM  specimenCommentCTE
							ORDER BY siOrder
							FOR XML PATH (''),root('test'),type
							).value('/test[1]','VARCHAR(MAX)'),1,1,''),' ;',';')
						AS specimenComment
	FROM  RecipientCTE, RS.dbo.tblPatient (NOLOCK) Patient
		 INNER JOIN RS.dbo.tblRequisition (NOLOCK)  requisition  ON(requisition.biPatientId=Patient.biId
																		AND requisition.chInloadSystem = Patient.chInloadSystem)
		 INNER JOIN  RS.dbo.tblSpecimen (NOLOCK) specimen  ON(specimen.biRequisitionId=requisition.biId
																AND requisition.chInloadSystem = specimen.chInloadSystem)
		 INNER JOIN RS.dbo.tblDepartment (NOLOCK)  department ON (Department.chDepartmentCode  = specimen.chDepartmentCode
														 AND Department.chDisciplineType=specimen.chDisciplineType
														 )
			 LEFT OUTER JOIN [DICT].[dbo].[tblTitle] (NOLOCK) Title ON(Title.chInloadSystem = requisition.chInloadSystem
																	AND Title.chAge =@ReqAge)
		WHERE  specimen.biId=@specimenId
		ORDER BY Patient.dtInloadUpdate DESC
END

