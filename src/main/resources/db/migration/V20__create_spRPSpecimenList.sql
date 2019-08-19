USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPSpecimenList]    Script Date: 4/3/2019 10:51:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************
2018-02-01	 Precious		select specimen list for a selected patient
************************************************************************************/
CREATE PROCEDURE [dbo].[spRPSpecimenList]
											@providerId INTEGER,
											@doctorMnemonic VARCHAR(10),
											@providerList VARCHAR(100)=0,
											@patientId BIGINT=0,
											@department VARCHAR(10)='',
											@profileList VARCHAR(100)='',
											@startDate DATE='',
											@endDate DATE='',
											@viewedStatus INT=0
AS
BEGIN
DECLARE		@tiLevel TINYINT,
			@chDepartmentCode CHAR(1),
			@chDisciplineType VARCHAR(3)

SELECT      @department=CASE WHEN @department='' THEN '*|*' ELSE @department END,
			@ProfileList= CASE WHEN @ProfileList= 0 THEN '' ELSE @ProfileList END,
			@chDepartmentCode = LEFT(@department,1),
			@chDisciplineType = SUBSTRING(@department,3,3),
			@endDate = DATEADD(d, 1, @endDate),
			@tiLevel = LEFT(@providerList,1),
			@providerList = SUBSTRING(@providerList, 3, 97),
			@chDepartmentCode = LEFT(@department,1),
			@chDisciplineType = SUBSTRING(@department,3,3)

SELECT  DISTINCT
				Requisition.dtCollection collectionDate,
 				Requisition.vchRequisitionNumber requisitionNo,
				Patient.biId patientId,
				--CASE WHEN viewedReq.id IS NULL THEN 0 ELSE 1 END ReqViewed,
				1 reqViewed,
				Specimen.chDisciplineType disciplineType,
				Requisition.biId requisitionId,
				Specimen.biId specimenId,
				Specimen.vchSpecimenNumber specimenNumber,
				Specimen.vchDepartment department,
			    Department.vchBackground backGroundColor,
				Department.vchForeground foreGroundColor,
				Department.chAbbreviationEng abbreviationEng
FROM RS.dbo.tblPatient  Patient
		INNER JOIN RS.dbo.tblRequisition  Requisition ON (Requisition.vchRequisitionUrn NOT LIKE '%J'
															     AND Requisition.biPatientId = Patient.biId
															     AND dtCollection >= CONVERT(VARCHAR(16),@startDate,120)
															     AND dtCollection < CONVERT(VARCHAR(16),@endDate,120)
														   )
		/*LEFT OUTER JOIN DEV.dbo.clinSysViewedRequsitions  viewedReq ON(viewedReq.requisitionId=Requisition.biId AND viewedReq.profileIdentifier=@MpNumber)*/
		INNER JOIN RS.dbo.tblDoctorRequisition  DoctorRequisition ON (DoctorRequisition.biRequisitionId = Requisition.biId)
		INNER JOIN RS.dbo.tblDoctor  Doctor ON (Doctor.iId = DoctorRequisition.iDoctorId)
		INNER JOIN RS.dbo.tblSpecimen  Specimen ON (Specimen.biRequisitionId = Requisition.biId
															 AND Specimen.chDepartmentCode = CASE WHEN @chDepartmentCode = '*' THEN Specimen.chDepartmentCode
																							ELSE @chDepartmentCode END
  															 AND Specimen.chDisciplineType = CASE WHEN @chDisciplineType = '*' THEN Specimen.chDisciplineType
												 											ELSE @chDisciplineType  END
																AND Specimen.vchStatus <>'CAN'
															)

		INNER JOIN RS.dbo.tblDepartment Department ON (Department.chDepartmentCode COLLATE DATABASE_DEFAULT = Specimen.chDepartmentCode
														AND Department.chDisciplineType=Specimen.chDisciplineType)
		INNER JOIN RS.dbo.tblResult  Result ON (Result.biSpecimenId=Specimen.biId)
		LEFT OUTER JOIN RS.dbo.tblProviderTestProfile (NOLOCK) ProviderTestProfile  ON (ProviderTestProfile.vchPrintNumber = Result.vchPrintNumberResult
																							AND ProviderTestProfile.chDisciplineType = Specimen.chDisciplineType
																							AND ProviderTestProfile.iProviderId = @profileList)

	  WHERE COALESCE(ProviderTestProfile.vchPrintNumber,'*' ) = CASE WHEN @profileList<>'' THEN COALESCE(ProviderTestProfile.vchPrintNumber,'@')
																ELSE COALESCE(ProviderTestProfile.vchPrintNumber,'*') END
			AND Patient.biPatientId = @patientId  --use bipatientId to include linked patient record
			AND (@doctorMnemonic='' OR Doctor.vchDoctorMnemonic =  @doctorMnemonic)
	 ORDER BY CollectionDate DESC, Requisition.vchRequisitionNumber
END