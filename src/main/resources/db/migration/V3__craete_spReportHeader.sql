USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportHeader]    Script Date: 4/3/2019 10:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
10-01-2019	Precious	select data for single report header
spReportHeader 9613767, 27660240, 48084368, 'LOUVP0'
spReportHeader 10641680,32251813,56877059,''
--spReportResultLab 822902,2018380,'E'
spReportFooter 2018380
select * from rs.dbo.tblspecimen where biid=56877059
select * from rs.dbo.tblrequisition where biid=10804688
822902
******************************************************************************************************* */
 CREATE PROC [dbo].[spReportHeader]  @patientId INTEGER,
									 @requisitionId INTEGER,
									 @specimenId INTEGER,
									 @DrMnemonic VARCHAR(20),
									 @language CHAR(1)
AS
BEGIN
	;WITH RecipientCTE AS
	(SELECT DISTINCT Doctor.iId iDoctorId,
					 chLanguage,
					 Doctor.vchName,
					 vchStreetAddress1,
					 vchStreetAddress2,
					 Doctor.vchDoctorMnemonic,
			LTRIM(ISNULL(vchStreetPostalCode,'')+ ' ' + ISNULL(vchStreetCity,'')) vchDrAddressCityCode,
			vchDoctorType
	FROM RS.dbo.tblDoctor (NOLOCK) Doctor
		WHERE (@DrMnemonic<>'' AND Doctor.vchDoctorMnemonic=@DrMnemonic)
			   AND chActive='Y'
	UNION

	SELECT DISTINCT Doctor.iId iDoctorId,
					 chLanguage,
					 Doctor.vchName,
					 vchStreetAddress1,
					 vchStreetAddress2,
					 Doctor.vchDoctorMnemonic,
					 LTRIM(ISNULL(vchStreetPostalCode,'')+ ' ' + ISNULL(vchStreetCity,'')) vchDrAddressCityCode,
					 vchDoctorType
	FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R' AND @DrMnemonic=''
	),
	OrderedTestCTE AS(SELECT DISTINCT TestOrder.vchPrintNumber,
									 LTRIM(RTRIM(REPLACE(TestOrder.vchOrderNameEng,'*','')))  vchOrderNameEng
						  FROM  RS.dbo.tblSpecimen (NOLOCK) Specimen
								INNER JOIN  RS.dbo.tblResult (NOLOCK)  Result ON(Result.biSpecimenId=Specimen.biId)
								LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK)  TestOrder ON ( TestOrder.vchPrintNumber=Result.vchPrintNumberOrder AND
																						TestOrder.chInloadSystem=Result.chInloadSystem
																						AND TestOrder.chDisciplineType = Specimen.chDisciplineType)
								WHERE Specimen.birequisitionId=@requisitionId
								--Specimen.vchStatus<>'CAN'
									AND LEFT(TestOrder.vchAbbreviatedNameEng,1)<>'~'  -- sign out tests must not appear on the report
								),
		CTEspecimenComment AS(SELECT DISTINCT  SpecimenComment.vchComment specimenComment, siOrder
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
		DoctorsCTE AS(SELECT Doctor.vchName,chReportType
							FROM RS.dbo.tblDoctor (NOLOCK) Doctor
							INNER JOIN  RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (DoctorRequisition.iDoctorId = Doctor.iId )
							WHERE DoctorRequisition.biRequisitionId=@requisitionId	)

	 SELECT TOP 1 Patient.bipatientId, Patient.biId, LTRIM(ISNULL(Patient.vchPatTitle,'')+ ' '+ ISNULL(patient.vchPatFirstName,'')+' '+ ISNULL(patient.vchPatSurname,'')) vchPatName,
						Patient.chPatGender  chPatGender,
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
									ELSE LEFT(Requisition.vchAge, 4) END +''+
						CASE WHEN SUBSTRING(Requisition.vchAge, 6, 4) = '000m' THEN ''
									WHEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),1,2) = '00' THEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),3,2)
									WHEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),1,1) = '0' THEN SUBSTRING(SUBSTRING(Requisition.vchAge, 6, 4),2,3)
									ELSE SUBSTRING(Requisition.vchAge, 6, 4) END + ''+
						CASE WHEN RIGHT(Requisition.vchAge, 4) = '000d' THEN ''
									WHEN SUBSTRING(RIGHT(Requisition.vchAge, 4),1,2) = '00' THEN SUBSTRING(RIGHT(Requisition.vchAge, 4),3,2)
									WHEN SUBSTRING(RIGHT(Requisition.vchAge, 4),1,1) = '0' THEN SUBSTRING(RIGHT(Requisition.vchAge, 4),2,3)
									ELSE RIGHT(Requisition.vchAge, 4) END+ ': ' + Patient.chPatGender + CASE WHEN	Patient.dPatDOB IS NULL OR Patient.dPatDOB = '1900-01-01' THEN ''
										 ELSE + ': ' + CONVERT(VARCHAR(10),Patient.dPatDOB,120) END ageGenderPatDOB,

						CASE WHEN  Patient.vchPatID IN  ('NOT AVAILABLE','NIE BESKIKBAAR NIE', '')
													THEN 'N/A'
						ELSE Patient.vchPatID END vchPatID,
						LTRIM(ISNULL(Patient.vchGuarTitle,'')+' '+ ISNULL(patient.vchGuarFirstName,'') +' '+ ISNULL(patient.vchGuarSurname,'')) vchGuarName,
						COALESCE(REPLACE(MedicalAid.vchName,'  ',' '), REPLACE(Patient.vchMedicalAid,'  ',' '),'Unknown') vchMedicalAid,
						Patient.vchMedicalAidNumber,
						REPLACE(RecipientCTE.vchName,'  ',' ') vchDrName,
						RecipientCTE.vchStreetAddress1 vchDrAddress1,
						RecipientCTE.vchStreetAddress2 vchDrAddress2,
						RecipientCTE.vchDrAddressCityCode,
						RecipientCTE.chLanguage,
						Patient.chInloadSystem,vchDoctorType,
						REPLACE(STUFF((SELECT
									'; ' + vchOrderNameEng  AS [data()]
							FROM  OrderedTestCTE
							ORDER BY vchPrintNumber
							FOR XML PATH (''),ROOT('test'),TYPE
							).value('/test[1]','VARCHAR(MAX)'),1,2,''),' ;',';')
						AS orderedTest,

				    CONVERT(VARCHAR(16),dtCollection,121)  AS CollectionDate,
					vchRequisitionNumber AS RequisitionNumber,
					CONVERT(VARCHAR(16),dtReceived,121)  AS recievedDate,
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
					CASE WHEN  @language='A' THEN department.vchNameAfr ELSE department.vchNameEng END vchDepartment,
					ISNULL(requisition.vchICD10List,'') ICD10List,
   					REPLACE(STUFF((SELECT
									'; ' + specimenComment AS [data()]
							FROM  CTEspecimenComment
							ORDER BY siOrder
							FOR XML PATH (''),root('test'),type
							).value('/test[1]','VARCHAR(MAX)'),1,2, ''),' ;',';')
						AS specimenComment
	FROM  RecipientCTE, RS.dbo.tblPatient (NOLOCK) Patient
		 INNER JOIN RS.dbo.tblRequisition (NOLOCK)  requisition  ON(requisition.biPatientId=Patient.biId)
		 INNER JOIN  RS.dbo.tblSpecimen (NOLOCK) specimen  ON(specimen.biRequisitionId=requisition.biId)
		 INNER JOIN RS.dbo.tblDepartment department ON (Department.chDepartmentCode  = specimen.chDepartmentCode
														 AND Department.chDisciplineType=specimen.chDisciplineType)
		 LEFT OUTER JOIN RS.dbo.tblMedicalAid (NOLOCK) MedicalAid ON (MedicalAid.vchMedicalAid = Patient.vchMedicalAid
																	AND MedicalAid.chInloadSystem = Patient.chInloadSystem)
		WHERE   specimen.biId=@specimenId
		   -- AND Patient.bipatientId=@patientId
		ORDER BY Patient.dtInloadUpdate DESC
END