USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultMicro]    Script Date: 4/3/2019 10:44:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportResultMicro]   @specimenId BIGINT,
											  @language CHAR(1) AS
BEGIN
	/*declare @biPatientId BIGINT, @biSpecimenId BIGINT, @chLanguage CHAR(1)
	select @biPatientId = 40147, @biSpecimenId = 71987, @chLanguage = 'E'
	*/
	SET NOCOUNT ON

	;WITH cteFooter
		(biSpecimenId, vchFooter) AS
	(SELECT @specimenId biSpecimenId,
			(SELECT SpecimenComment.vchComment + '|' AS [data()]
				FROM RS.dbo.tblSpecimenCommentLink (NOLOCK) SpecimenCommentLink
					INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK) SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId )
				WHERE SpecimenCommentLink.biSpecimenId = @specimenId
						AND SpecimenCommentLink.chTag = 'Z'
						AND SpecimenComment.vchComment IS NOT NULL
						AND SpecimenComment.vchComment <> ''
				ORDER BY SpecimenCommentLink.chTag, SpecimenCommentLink.siOrder
				FOR XML PATH ('')
			) AS vchFooter
	),
	cteOrganism ( biSpecimenId,iOrganismNumberMax) AS
	(SELECT biSpecimenId,
			MAX(Micro.iOrganismNumber) iOrganismNumberMax
			FROM RS.dbo.tblMicro (NOLOCK) Micro WHERE biSpecimenId = @specimenId
			GROUP BY biSpecimenId
	) ,
	cteOrganismComment (biMicroId, vchComment, siMicroOrder, tiMicroType) AS
			(SELECT DISTINCT Micro.biId,
					MicroResultComment.vchComment,
   					MicroResultCommentLink.siOrder,
					MicroResultCommentLink.tiMicroType
				FROM RS.dbo.tblMicro (NOLOCK) Micro
					inner  JOIN RS.dbo.tblMicroResultCommentLink (NOLOCK) MicroResultCommentLink ON (MicroResultCommentLink.biMicroId = Micro.biId)
 					inner  JOIN RS.dbo.tblResultComment (NOLOCK) MicroResultComment ON (MicroResultCommentLink.iResultCommentId = MicroResultComment.iId)
				WHERE biSpecimenId = @specimenId
	) ,
	cteResultComment (biResultId, vchComment, chTagSort, siOrderSort) AS

		(SELECT DISTINCT Result.biId,
			ResultComment.vchComment,
			ResultCommentLink.chTag,
			ResultCommentLink.siOrder

			FROM RS.dbo.tblResult (NOLOCK) Result
			inner JOIN RS.dbo.tblResultCommentLink (NOLOCK) ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
			inner JOIN RS.dbo.tblResultComment (NOLOCK) ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
			 WHERE biSpecimenId = @specimenId
	 )
	SELECT  DISTINCT 1 itag, Result.vchPrintNumberResult vchPrintNumberResultSort,
			Result.vchMethod,
			Result.vchPrompt vchResultPrompt,
			CASE WHEN @language = 'E' AND Result.vchResult = 'ND|' AND Result.vchPrompt = '0' THEN 'Test not done'
				WHEN @language = 'A' AND Result.vchResult = 'ND|' AND Result.vchPrompt = '0' THEN 'Toets nie gedoen nie'
				ELSE
					CASE WHEN Result.vchResult LIKE '%|'
							THEN LEFT(Result.vchResult, LEN(Result.vchResult) - 1)
						WHEN Result.vchResult LIKE '@%' THEN NULL ELSE Result.vchResult END  END vchResult,
			ISNULL(Result.vchNormalRange,'')+' '+ISNULL(Result.vchUnit,'')vchReference,
			Result.vchAbnormalFlag,
				Organism.vchOrganismName,
			Organism.vchPrompt vchOrganismPrompt,
			Organism.vchPromptResponse,
			Micro.iOrganismNumber iOrganismNumber,
			''  vchMicroComment,
    		0 siMicroOrder,
			0 tiMicroType,
			CASE WHEN @language= 'A' THEN REPLACE(TEST.vchOrderNameAfr, '*','')
				 ELSE  REPLACE(TEST.vchOrderNameEng, '*','') END vchResulted,
  			0 iOrganismNumberMax,
			cteResultComment.vchComment vchResultComment,
			cteResultComment.chTagSort ,
			cteResultComment.siOrderSort,
			vchFooter,
			Result.tiSpecialResult,
			Result.iPrintOrder,
			Test.chConfidential,
			@specimenId biSpecimenId

	FROM RS.dbo.tblResult (NOLOCK) Result
		INNER JOIN RS.dbo.tblSpecimen (NOLOCK) Specimen ON (Specimen.biId = Result.biSpecimenId)
		INNER JOIN cteFooter cteFooter ON (cteFooter.biSpecimenId = Specimen.biId)


		LEFT OUTER JOIN RS.dbo.tblMicro (NOLOCK) Micro ON ( Micro.biResultId = Result.biId)
		LEFT OUTER JOIN cteOrganism AS MicroOrganism ON (Specimen.biId = MicroOrganism.biSpecimenId)
		LEFT OUTER JOIN RS.dbo.tblOrganism (NOLOCK) Organism ON (Organism.iId = Micro.iOrganismId)

		LEFT OUTER JOIN cteResultComment AS cteResultComment ON (Result.biId = cteResultComment.biResultId)
		LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK) Test ON (Test.vchPrintNumber = Result.vchPrintNumberResult AND
										Test.chInloadsystem = Result.chInloadsystem AND
										Test.chDisciplineType = Specimen.chDisciplineType)

	WHERE Result.biSpecimenId = @specimenId

	UNION

	SELECT  DISTINCT  2 itag,  Result.vchPrintNumberResult vchPrintNumberResultSort,
			Result.vchMethod,
			Result.vchPrompt vchResultPrompt,
			CASE WHEN @language = 'E' AND Result.vchResult = 'ND|' AND Result.vchPrompt = '0' THEN 'Test not done'
				WHEN @language = 'A' AND Result.vchResult = 'ND|' AND Result.vchPrompt = '0' THEN 'Toets nie gedoen nie'
				ELSE Result.vchResult END vchResult,
			ISNULL(Result.vchNormalRange,'')+' '+ISNULL(Result.vchUnit,'')vchReference,
			Result.vchAbnormalFlag,
			Organism.vchOrganismName,
			Organism.vchPrompt vchOrganismPrompt,
			Organism.vchPromptResponse,
			Micro.iOrganismNumber iOrganismNumber,

			OrganismComment.vchComment vchMicroComment,
   			OrganismComment.siMicroOrder,
			OrganismComment.tiMicroType,
			CASE WHEN @language= 'A' THEN REPLACE(TEST.vchOrderNameAfr, '*','')
				 ELSE  REPLACE(TEST.vchOrderNameEng, '*','') END vchResulted,
  			iOrganismNumberMax,
			''  vchResultComment,
			'' chTagSort ,
			0 siOrderSort,
			vchFooter,
			Result.tiSpecialResult	,
			Result.iPrintOrder,
			Test.chConfidential,
			@specimenId biSpecimenId


	FROM RS.dbo.tblResult (NOLOCK) Result
		INNER JOIN RS.dbo.tblSpecimen (NOLOCK) Specimen ON (Specimen.biId = Result.biSpecimenId)
		INNER JOIN cteFooter cteFooter ON (cteFooter.biSpecimenId = Specimen.biId)

		INNER JOIN  RS.dbo.tblMicro (NOLOCK) Micro ON ( Micro.biResultId = Result.biId)
		LEFT OUTER JOIN cteOrganism AS MicroOrganism ON (Specimen.biId = MicroOrganism.biSpecimenId)
		LEFT OUTER JOIN RS.dbo.tblOrganism (NOLOCK) Organism ON (Organism.iId = Micro.iOrganismId)
		LEFT OUTER JOIN cteOrganismComment AS OrganismComment ON (Micro.biId = OrganismComment.biMicroId)
		LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK) Test ON (Test.vchPrintNumber = Result.vchPrintNumberResult AND
										Test.chInloadsystem = Result.chInloadsystem AND
										Test.chDisciplineType = Specimen.chDisciplineType)
	WHERE Result.biSpecimenId = @specimenId
		AND COALESCE(OrganismComment.tiMicroType,1)  <> 2
	ORDER BY vchprintnumberResultSort, iPrintOrder, vchResultPrompt, tiSpecialResult,iOrganismNumber, chTagSort, siOrderSort,  tiMicroType, siMicroOrder
END