USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spReportResultMicroMIC') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spReportResultMicroMIC
	IF OBJECT_ID('dbo.spReportResultMicroMIC') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spReportResultMicroMIC]    Script Date: 5/22/2019 10:50:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportResultMicroMIC] @specimenId BIGINT AS

BEGIN
	SELECT  Organism.vchOrganismName,	OrganismAntibiotic.vchAntibioticGroup  ,
			CASE WHEN OrganismAntibiotic.vchAntibioticGroup = '' THEN 'ZZZZZZZZZZ'
				ELSE OrganismAntibiotic.vchAntibioticGroup END  vchAntibioticGroupSORT,
			OrganismAntibiotic.vchAntibioticGeneration,
			OrganismAntibiotic.vchAntibioticName vchAntibioticName,
			Micro.vchMIC [M.I.C.],
			OrganismAntibiotic.chSensitivity RX,@specimenId biSpecimenId

	FROM RS.dbo.tblResult (NOLOCK) Result
		INNER JOIN RS.dbo.tblSpecimen (NOLOCK) Specimen ON (Specimen.biId = Result.biSpecimenId)
		INNER JOIN RS.dbo.tblMicro (NOLOCK) Micro ON (Micro.biResultId = Result.biId
										AND Micro.vchMIC IS NOT NULL)
		INNER JOIN RS.dbo.tblOrganism (NOLOCK) Organism ON (Organism.iId = Micro.iOrganismId)
		INNER JOIN RS.dbo.tblOrganismSensitivity (NOLOCK) OrganismSensitivity  ON (OrganismSensitivity.iId = Micro.iOrganismSensitivityId)
		INNER JOIN RS.dbo.tblOrganismAntibiotic (NOLOCK) OrganismAntibiotic ON (OrganismAntibiotic.iId = Micro.iOrganismAntibioticId)
	WHERE Result.biSpecimenId= @specimenId
		AND OrganismAntibiotic.vchAntibioticName IS NOT NULL
	ORDER BY vchAntibioticGroupSORT,
			OrganismAntibiotic.vchAntibioticGeneration,
			OrganismAntibiotic.vchAntibioticName
END