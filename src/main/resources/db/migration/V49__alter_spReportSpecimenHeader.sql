USE [ResultsPortal]
GO
IF OBJECT_ID('dbo.spReportSpecimenHeader') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportSpecimenHeader
	IF OBJECT_ID('dbo.spReportSpecimenHeader') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportSpecimenHeader]    Script Date: 5/16/2019 3:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
Created by:		Precious
Create date:	2019-01-10
Details:		Select data for report header
Reference		Date		Author			Description
******************************************************************************************************* */
CREATE PROCEDURE [dbo].[spReportSpecimenHeader]
										@specimenId BIGINT,
										@requisitionId BIGINT AS
BEGIN
	DECLARE @docLanguage CHAR(1)

	SELECT @docLanguage=chLanguage
		FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R'

    SELECT DISTINCT
				SpecimenComment.vchComment, siOrder,chTag,
				CASE WHEN RTRIM(LTRIM(specimen.vchstatus))IN('COMP','SOUT') AND @docLanguage='A' THEN 'Finale'
					 WHEN RTRIM(LTRIM(specimen.vchstatus)) IN('COMP','SOUT') AND @docLanguage='E' THEN 'Final'
					 WHEN RTRIM(LTRIM(specimen.vchstatus))NOT IN('COMP','SOUT','CAN') AND @docLanguage='A' THEN 'Voorlopige'
					 WHEN RTRIM(LTRIM(specimen.vchstatus))NOT IN('COMP','SOUT','CAN') AND @docLanguage='E' THEN 'Preliminary'
					 WHEN RTRIM(LTRIM(specimen.vchstatus))IN('CAN') AND @docLanguage='A' THEN 'Gekanselleer'
					 WHEN RTRIM(LTRIM(specimen.vchstatus)) IN('CAN') AND @docLanguage='E' THEN 'Cancelled'
					 END specimenStatus,
				CASE WHEN specimen.chDisciplineType='MIC' THEN 'Microbiology'
					 WHEN specimen.chDisciplineType='LAB' THEN 'Clinical'
					 WHEN specimen.chDisciplineType='PTH' THEN 'Apath' END displineType,
					 specimen.chDepartmentCode
		FROM RS.dbo.tblSpecimenCommentLink (NOLOCK)  SpecimenCommentLink
				INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK)  SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId)
				INNER JOIN RS.dbo.tblSpecimen  (NOLOCK)  specimen ON (specimen.biId=SpecimenCommentLink.biSpecimenId)
		WHERE
		SpecimenCommentLink.chTag ='H'
		AND NULLIF(SpecimenComment.vchComment,'') IS NOT NULL
		AND specimen.vchStatus<>'CAN'
		AND NULLIF(specimen.vchDepartment,'') IS NOT NULL
		--AND specimen.chDepartmentCode NOT IN('C','Q','Z')
		AND specimen.biId=@specimenId
		ORDER BY siOrder
 END