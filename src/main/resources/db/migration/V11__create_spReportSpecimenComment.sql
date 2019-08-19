USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportSpecimenComment]    Script Date: 4/3/2019 10:46:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spReportSpecimenComment 20596066
CREATE PROCEDURE [dbo].[spReportSpecimenComment]
										@specimenId BIGINT AS
BEGIN
  SELECT DISTINCT
				SpecimenComment.vchComment, siOrder,chTag,
				CASE WHEN RTRIM(LTRIM(specimen.vchstatus))='COMP' THEN 'Final'
					 WHEN specimen.vchstatus='CAN' THEN 'Cancelled' ELSE 'Preliminary' END specimenStatus,
				CASE WHEN specimen.chDisciplineType='MIC' THEN 'Microbiology'
					 WHEN specimen.chDisciplineType='LAB' THEN 'Clinical'
					 WHEN specimen.chDisciplineType='PTH' THEN 'Apath' END displineType,
					 specimen.chDepartmentCode
		FROM RS.dbo.tblSpecimenCommentLink (NOLOCK)  SpecimenCommentLink
				INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK)  SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId)
				INNER JOIN RS.dbo.tblSpecimen  (NOLOCK)  specimen ON (specimen.biId=SpecimenCommentLink.biSpecimenId)
		WHERE
		SpecimenCommentLink.chTag NOT IN('H','Z')
		AND NULLIF(SpecimenComment.vchComment,'') IS NOT NULL
		AND SpecimenComment.vchComment NOT LIKE '@%'
		AND specimen.vchStatus<>'CAN'
		AND NULLIF(specimen.vchDepartment,'') IS NOT NULL
		--AND specimen.chDepartmentCode NOT IN('C','Q','Z')
		AND specimen.biId=@specimenId
		ORDER BY siOrder
 END