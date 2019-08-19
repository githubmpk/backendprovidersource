USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultApath]    Script Date: 4/3/2019 10:40:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportResultApath] @patientId BIGINT,
											  @specimenId BIGINT,
											  @language CHAR(1) AS
BEGIN
	SET NOCOUNT ON

	;WITH FooterCTE AS
	(SELECT @specimenId biSpecimenId,
		( SELECT SpecimenComment.vchComment +   '|'  AS [data()]
			FROM RS.dbo.tblSpecimenCommentLink (NOLOCK) SpecimenCommentLink
				INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK)  SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId )
			WHERE SpecimenCommentLink.biSpecimenId = @specimenId
				AND SpecimenCommentLink.chTag = 'Z'
				AND SpecimenComment.vchComment IS NOT NULL
				AND SpecimenComment.vchComment <> ''
			ORDER BY chTag, siOrder
			FOR XML PATH ('')
		) AS vchFooter
	)

	SELECT DISTINCT	Result.vchPrintNumberResult,
					NULLIF(ResultComment.vchComment,'') + ' ' + COALESCE(ICD10.vchDescription,'') vchComment ,
					Result.iPrintOrder,
					ResultCommentLink.siOrder,
				    ResultCommentLink.chTag,
				    FooterCTE.vchFooter,Specimen.vchDepartment
	FROM RS.dbo.tblSpecimen (NOLOCK)  Specimen
		INNER JOIN FooterCTE FooterCTE ON (FooterCTE.biSpecimenId = Specimen.biId)
		INNER JOIN RS.dbo.tblResult(NOLOCK)  Result ON (Result.biSpecimenId = Specimen.biId )
		LEFT OUTER JOIN RS.dbo.tblResultCommentLink (NOLOCK)  ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
		LEFT OUTER JOIN RS.dbo.tblResultComment (NOLOCK)  ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
		LEFT OUTER JOIN	RS.dbo.tblICD10 (NOLOCK)  ICD10 On (ICD10.vchCode = ResultComment.vchComment)


	WHERE Specimen.biId = @specimenId
	AND iPrintOrder<>999 and vchComment NOT LIKE '@%'
	ORDER BY Result.iPrintOrder, ResultCommentLink.chTag, ResultCommentLink.siOrder
END