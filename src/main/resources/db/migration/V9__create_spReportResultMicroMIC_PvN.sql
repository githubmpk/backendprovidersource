USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultMicroMIC_PvN]    Script Date: 4/3/2019 10:46:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spReportResultMicroMIC_PvN]
--declare
@specimenId BIGINT

AS

--set @specimenId = 48084368

BEGIN

	SELECT
		o.vchOrganismName,
		oa.vchAntibioticGroup,
		vchAntibioticGroupSORT = CASE
									WHEN oa.vchAntibioticGroup = '' THEN 'ZZZZZZZZZZ'
									ELSE oa.vchAntibioticGroup
		END,
		vchAntibioticGeneration = oa.vchAntibioticGeneration,
		oa.vchAntibioticName,
		[M.I.C.] = m.vchMIC ,
		RX = oa.chSensitivity,
		biSpecimenId = r.biSpecimenId,
		o.vchOrganismNameAbbreviation,
		m.iOrganismNumber
	FROM
		RS.dbo.tblResult (NOLOCK) r
		INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
		r.biSpecimenId = s.biId
		INNER JOIN RS.dbo.tblMicro (NOLOCK) m ON
		r.biId = m.biResultId
	--AND m.vchMIC IS NOT NULL
		INNER JOIN RS.dbo.tblOrganism (NOLOCK) o ON
		m.iOrganismId = o.iId
		INNER JOIN RS.dbo.tblOrganismSensitivity (NOLOCK) os ON
		m.iOrganismSensitivityId = os.iId
		INNER JOIN RS.dbo.tblOrganismAntibiotic (NOLOCK) oa ON
		m.iOrganismAntibioticId = oa.iId
	WHERE
		r.biSpecimenId= @specimenId
	--AND OrganismAntibiotic.vchAntibioticName IS NOT NULL
	ORDER BY vchAntibioticGroupSORT,
			oa.vchAntibioticGeneration,
			oa.vchAntibioticName

END