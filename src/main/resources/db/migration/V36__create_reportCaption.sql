USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportCaption]    Script Date: 4/23/2019 3:56:14 PM ******/
SET ANSI_NULLS ON
GO

IF OBJECT_ID('dbo.spReportCaption') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportCaption
	IF OBJECT_ID('dbo.spReportCaption') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
SET QUOTED_IDENTIFIER ON
GO

/* *******************************************************************************************************
Created by:		Precious
Create date:	2019-01-10
Details:		Select captions  for  report
Reference		Date		Author			Description
******************************************************************************************************* */
 CREATE PROC [dbo].[spReportCaption]  @patientId INTEGER,
									 @requisitionId INTEGER


AS
BEGIN
	--DECLARE @selectColumn VARCHAR(20)
	--SELECT @selectColumn =CASE WHEN @language='A' THEN 'afrikaans' ELSE 'english' END


	--;WITH CTEreportCaption AS (SELECT CASE WHEN @language='A' THEN afrikaans ELSE english END
	--								FROM [RS].[dbo].[tblReportCaption]
	--							PIVOT (
	--							  MAX(afrikaans)
	--							  FOR name IN (
	--								report,age,sex
	--							  )
	--							)
	--							 )

	SELECT DISTINCT
		 CASE WHEN DM.[chLanguage]='A' THEN 'Verslag' ELSE 'Report' END report
		,CASE WHEN DM.[chLanguage]='A' THEN 'Kontak Nr:' ELSE 'Contact No:' END contactNo
		,CASE WHEN DM.[chLanguage]='A' THEN 'Verwys deur:' ELSE 'Referred by:' END referringDoc
		,CASE WHEN DM.[chLanguage]='A' THEN 'Afskrif aan:' ELSE 'Copy to:' END copiesTo
		,CASE WHEN DM.[chLanguage]='A' THEN 'Fonds:' ELSE 'Med Aid:' END medicalAid
		,CASE WHEN DM.[chLanguage]='A' THEN 'Lidno:' ELSE 'Member No:' END memberNumber
		,CASE WHEN DM.[chLanguage]='A' THEN 'Oud:m/v:Geb:' ELSE 'Age:Sex:DoB:' END ageGender
		,CASE WHEN DM.[chLanguage]='A' THEN 'prosedure:' ELSE 'Procedure:' END microProcedure
		,CASE WHEN DM.[chLanguage]='A' THEN 'Bron: ' ELSE 'source: ' END specSource
		,CASE WHEN DM.[chLanguage]='A' THEN 'Geskep: ' ELSE 'Generated: ' END generated
		,CASE WHEN DM.[chLanguage]='A' THEN 'bladsy ' ELSE 'Page ' END pageNumber
		,CASE WHEN DM.[chLanguage]='A' THEN ' van ' ELSE ' of ' END pageOf
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_Comment],FS.[Hdr_Comment],''),':','')))+':' clinicalData
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_RefNum],FS.[Hdr_RefNum],''),':','')))+':' fileNo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_OtherNum],FS.[Hdr_OtherNum],''),':','')))+':' otherNo
		--,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_RefDoc],FS.[Hdr_RefDoc],''),':','')))+':' referringDoc
		--,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_CopyDoctor],FS.[Hdr_CopyDoctor],''),':','')))+':' copiesTo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_GuarAlt],FS.[Hdr_GuarAlt],''),':','')))+':'  guarantor
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatTelH],FS.[Hdr_PatTelH],''),':','')))+':' patientHomeTel
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatTelW],FS.[Hdr_PatTelW],''),':','')))+':' patientWorkTel
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatTelM],FS.[Hdr_PatTelM],''),':','')))+':' patientMobileTel
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PateMail],FS.[Hdr_PateMail],''),':','')))+':' patientEmail
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatDetail],FS.[Hdr_PatDetail],''),':','')))+':' patientDetails
		--,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_BirthDate],FS.[Hdr_BirthDate],''),':','')))+':' dob
		--,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatAge],FS.[Hdr_PatAge],''),':','')))+':' age
		--,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatGender],FS.[Hdr_PatGender],''),':','')))+':' sex
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PatID],FS.[Hdr_PatID],''),':','')))+':' patientID
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_PracNo],FS.[Hdr_PracNo],''),':','')))+':' practiceNo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_SpcNo],FS.[Hdr_SpcNo],''),':','')))+':' specimenNo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdt_ReportTo],FS.[Hdt_ReportTo],''),':','')))+':' reportTo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_CollDate],FS.[Hdr_CollDate],''),':','')))+':' collectionDate
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_RcvDate],FS.[Hdr_RcvDate],''),':','')))+':' receivedDate
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_RptDate],FS.[Hdr_RptDate],''),':','')))+':' reportDate
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_AddInfo],FS.[Hdr_AddInfo],''),':','')))+':' additionalInfo
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_Orders],FS.[Hdr_Orders],''),':','')))+':' testsRequested
		--,COALESCE(FH.[Hdr_PrvINR],FS.[Hdr_PrvINR],'')
		,RTRIM(LTRIM(REPLACE(COALESCE(FH.[Hdr_LabRef],FS.[Hdr_LabRef],''),':','')))+':' requisitionNo
		,COALESCE(FH.[Hdr_TestName],FS.[Hdr_TestName],'') test
		,COALESCE(FH.[Hdr_Result],FS.[Hdr_Result],'') result
		,CASE WHEN DM.[chLanguage]='A' THEN 'Vlag' ELSE 'flag' END flag
		,COALESCE(FH.[Hdr_RefRange],FS.[Hdr_RefRange],'') referenceRange

	  FROM [RS].[dbo].[tblPatient] P (NOLOCK)
	  INNER JOIN [RS].[dbo].[tblRequisition] E (NOLOCK)
	  ON E.[biPatientId]=P.[biId]
	  INNER JOIN [RS].[dbo].[tblDoctorRequisition] DR (NOLOCK)
	  ON DR.[biRequisitionId]=E.[biId]
	  AND [chReportType]='R'
	  INNER JOIN [RS].[dbo].[tblDoctor] D (NOLOCK)
	  ON D.[iId]=DR.[iDoctorId]
	  INNER JOIN [DICT].[dbo].[tblDoctor] DM (NOLOCK)
	  ON  DM.[chInloadSystem]=P.[chInloadSystem]
	  AND DM.[vchDoctorMnemonic]=D.[vchDoctorMnemonic]

	  LEFT OUTER JOIN [RSReporting].[dbo].[tblRSR_Field_Names] FH (NOLOCK)
	  ON FH.[Hdr_Sys]=P.[chInloadSystem]  COLLATE DATABASE_DEFAULT
	  AND FH.[Hdr_Set]=(CASE WHEN DM.[vchAdminScreenType]='.' THEN (CASE WHEN DM.[chLanguage]='A' THEN 'a.STD' ELSE '.STD' END) ELSE (CASE WHEN DM.[chLanguage]='A' THEN 'a.' ELSE '' END)+DM.[vchAdminScreenType] END)  COLLATE DATABASE_DEFAULT
	  AND FH.[Hdr_Status]=(CASE WHEN REPLACE(P.[vchPatType],' ','_')='REG_SDC' THEN 'REG_CLI' ELSE REPLACE(P.[vchPatType],' ','_') END)  COLLATE DATABASE_DEFAULT

		LEFT OUTER JOIN [RSReporting].[dbo].[tblRSR_Field_Names] FS (NOLOCK)
	  ON FS.[Hdr_Sys]=P.[chInloadSystem]  COLLATE DATABASE_DEFAULT
	  AND FS.[Hdr_Set]=(CASE WHEN DM.[chLanguage]='A' THEN 'a.STD' ELSE '.STD' END) COLLATE DATABASE_DEFAULT
	  AND FS.[Hdr_Status]='REG_CLI'  COLLATE DATABASE_DEFAULT
	  WHERE P.biId=@patientId AND E.biId=@requisitionId
END