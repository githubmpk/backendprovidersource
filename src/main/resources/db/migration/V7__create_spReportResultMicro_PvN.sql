USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultMicro_PvN]    Script Date: 4/3/2019 10:45:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from RS.dbo.tblSpecimen where biRequisitionId = 32370207
--select * from RS.dbo.tblRequisition where biId = 32370207
--select * from RS.dbo.tblRequisition where vchRequisitionNumber = '722682749'

CREATE PROCEDURE [dbo].[spReportResultMicro_PvN]
--declare
@specimenId BIGINT,
@language CHAR(1)

AS

--set @specimenId = 57117119 --48084368
--set @language = 'E'

SET NOCOUNT ON;

DECLARE @procedures TABLE (vchPrintNumberResult varchar(40), vchMethod varchar(100), vchResulted varchar(100))
INSERT INTO @procedures
SELECT
	r.vchPrintNumberResult,
	r.vchMethod,
	vchResulted = CASE @language
		WHEN 'A' THEN REPLACE(t.vchOrderNameAfr, '*','')
		ELSE REPLACE(t.vchOrderNameEng, '*','')
	END
	--,*
FROM
	RS.dbo.tblResult (NOLOCK) r
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
	r.vchPrintNumberResult = t.vchPrintNumber
AND r.chInloadsystem = t.chInloadsystem
AND	s.chDisciplineType = t.chDisciplineType
LEFT JOIN (
			SELECT
				r.*
			FROM
				RS.dbo.tblResult (NOLOCK) r
				INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
				r.biSpecimenId = s.biId
				LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
				r.vchPrintNumberResult = t.vchPrintNumber
			AND r.chInloadsystem = t.chInloadsystem
			AND	s.chDisciplineType = t.chDisciplineType
			WHERE
				r.biSpecimenId = @specimenId
			AND	vchMethod IS NULL
				) results ON
	r.vchPrintNumberResult = results.vchPrintNumberResult
WHERE
	r.biSpecimenId = @specimenId
AND	r.vchMethod IS NOT NULL
AND	results.biId IS NULL

DECLARE @organism TABLE (biSpecimenId bigint, iOrganismNumberMax int)
INSERT INTO @organism
SELECT
	biSpecimenId,
	MAX(m.iOrganismNumber)
	FROM
RS.dbo.tblMicro (NOLOCK) m
WHERE
	m.biSpecimenId = @specimenId
GROUP BY
	biSpecimenId

DECLARE @organismComment TABLE (biMicroId bigint, vchComment varchar(200), siMicroOrder int, tiMicroType int)
INSERT INTO @organismComment
SELECT DISTINCT
	m.biId,
	mrc.vchComment,
   	mrcl.siOrder,
	mrcl.tiMicroType
FROM
	RS.dbo.tblMicro (NOLOCK) m
	INNER JOIN RS.dbo.tblMicroResultCommentLink (NOLOCK) mrcl ON
	mrcl.biMicroId = m.biId
 	INNER JOIN RS.dbo.tblResultComment (NOLOCK) mrc ON
	mrcl.iResultCommentId = mrc.iId
WHERE
	biSpecimenId = @specimenId

DECLARE @data TABLE (vchPrintNumberResult varchar(40), vchMethod varchar(35),vchResulted varchar(200), vchPrompt varchar(30), vchResult varchar(200),
						vchAbnormalFlag varchar(10), vchReference varchar(200), iOrganismNumber int, iPrintOrder int, chConfidential varchar(10), resultType char(1), resultTypeOrder tinyint,
							vchOrganismNameAbbreviation varchar(100))

INSERT INTO @data
SELECT
	r.vchPrintNumberResult,
	results.vchMethod,
	vchResulted = CASE @language
		WHEN 'A' THEN REPLACE(t.vchOrderNameAfr, '*','')
		ELSE REPLACE(t.vchOrderNameEng, '*','')
	END,
	vchPrompt = CASE
					WHEN r.vchPrompt = '0' THEN ''
					ELSE r.vchPrompt
	END,
	vchResult = CASE
					WHEN @language = 'E' AND r.vchResult = 'ND|' AND r.vchPrompt = '0' THEN 'Test not done'
					WHEN @language = 'A' AND r.vchResult = 'ND|' AND r.vchPrompt = '0' THEN 'Toets nie gedoen nie'
					ELSE
						CASE
							WHEN r.vchResult LIKE '%|' THEN LEFT(r.vchResult, LEN(r.vchResult) - 1)
							WHEN r.vchResult LIKE '@%' THEN NULL ELSE r.vchResult
						END
	END,
	r.vchAbnormalFlag,
	vchReference = ISNULL(r.vchNormalRange,'') + ' ' + ISNULL(r.vchUnit,''),
	iOrganismNumber = null,
	r.iPrintOrder,
	t.chConfidential,
	resultType = 'R', -- result table,
	resultTypeOrder = 0,
	vchOrganismNameAbbreviation = null
	--,*
FROM
	RS.dbo.tblResult (NOLOCK) r
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
	r.vchPrintNumberResult = t.vchPrintNumber
AND r.chInloadsystem = t.chInloadsystem
AND	s.chDisciplineType = t.chDisciplineType
	LEFT JOIN (
			SELECT
				r.*
			FROM
				RS.dbo.tblResult (NOLOCK) r
				INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
				r.biSpecimenId = s.biId
				LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
				r.vchPrintNumberResult = t.vchPrintNumber
			AND r.chInloadsystem = t.chInloadsystem
			AND	s.chDisciplineType = t.chDisciplineType
			WHERE
				r.biSpecimenId = @specimenId
			AND	vchMethod IS NOT NULL
				) results ON
	r.vchPrintNumberResult = results.vchPrintNumberResult

WHERE
	r.biSpecimenId = @specimenId
AND	r.vchMethod IS NULL
AND	t.chReportable = 'Y'

--UNION
INSERT INTO @data
SELECT DISTINCT
	p.vchPrintNumberResult,
	p.vchMethod,
	p.vchResulted,
	vchPrompt = CASE @language WHEN 'E' THEN 'Organism ' ELSE 'Organisme ' END + CONVERT(varchar(10), m.iOrganismNumber) + '',
	vchResult = vchOrganismNameList,
	vchAbnormalFlag = CASE WHEN NOT r.vchAbnormalFlag IS NULL THEN r.vchAbnormalFlag ELSE '#' END,
	vchReference = ISNULL(r.vchNormalRange,'')+' '+ISNULL(r.vchUnit,''),
	m.iOrganismNumber,
	r.iPrintOrder,
	t.chConfidential,
	resultType = 'M', -- micro table
	resultTypeOrder = 1,
	o.vchOrganismNameAbbreviation
	--,*
FROM
	@procedures p
	INNER JOIN RS.dbo.tblResult (NOLOCK) r ON
	p.vchPrintNumberResult = r.vchPrintNumberResult COLLATE Latin1_General_CI_AS
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	INNER JOIN  RS.dbo.tblMicro (NOLOCK) m ON
	r.biId = m.biResultId
	LEFT OUTER JOIN @organism AS mo ON
	s.biId = mo.biSpecimenId
	LEFT OUTER JOIN RS.dbo.tblOrganism (NOLOCK) o ON
	m.iOrganismId = o.iId
	LEFT OUTER JOIN @organismComment AS oc ON
	m.biId = oc.biMicroId
	LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK) t ON
	t.vchPrintNumber = r.vchPrintNumberResult
AND t.chInloadsystem = r.chInloadsystem
AND t.chDisciplineType = s.chDisciplineType
WHERE
	r.biSpecimenId = @specimenId
AND COALESCE(oc.tiMicroType,1)  <> 2
AND	t.chReportable = 'Y'
--ORDER BY p.vchPrintNumberResult, m.iOrganismNumber

UNION


SELECT DISTINCT
	p.vchPrintNumberResult,
	p.vchMethod,
	p.vchResulted,
	--vchPrompt = o.vchPrompt,
	vchPrompt = replace(o.vchPrompt, LEFT(o.vchPrompt, CHARINDEX(' ', o.vchPrompt)), ' ' + LEFT(o.vchPrompt, CHARINDEX(' ', o.vchPrompt)-1)),
	vchResult = o.vchPromptResponse,
	r.vchAbnormalFlag,
	vchReference = ISNULL(r.vchNormalRange,'')+' '+ISNULL(r.vchUnit,''),
	m.iOrganismNumber,
	r.iPrintOrder,
	t.chConfidential,
	resultType = 'M', -- micro table
	resultTypeOrder = 2,
	--o.vchOrganismNameAbbreviation
	vchOrganismNameAbbreviation = null
	--,*
FROM
	@procedures p
	INNER JOIN RS.dbo.tblResult (NOLOCK) r ON
	p.vchPrintNumberResult = r.vchPrintNumberResult COLLATE Latin1_General_CI_AS
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	INNER JOIN  RS.dbo.tblMicro (NOLOCK) m ON
	r.biId = m.biResultId
	LEFT OUTER JOIN @organism AS mo ON
	s.biId = mo.biSpecimenId
	LEFT OUTER JOIN RS.dbo.tblOrganism (NOLOCK) o ON
	m.iOrganismId = o.iId
	LEFT OUTER JOIN @organismComment AS oc ON
	m.biId = oc.biMicroId
	LEFT OUTER JOIN RS.dbo.tblTest (NOLOCK) t ON
	t.vchPrintNumber = r.vchPrintNumberResult
AND t.chInloadsystem = r.chInloadsystem
AND t.chDisciplineType = s.chDisciplineType
WHERE
	r.biSpecimenId = @specimenId
AND COALESCE(oc.tiMicroType,1)  <> 2
AND	t.chReportable = 'Y'
ORDER BY
	p.vchPrintNumberResult,
	m.iOrganismNumber


SELECT
	vchPrintNumberResult,
	vchMethod,
	vchResulted,
	vchPrompt,
	vchResult,
	vchAbnormalFlag,
	vchReference,
	iOrganismNumber,
	iPrintOrder,
	chConfidential,
	resultType,
	resultTypeOrder,
	vchOrganismNameAbbreviation
FROM
	@data
ORDER BY
	1, iOrganismNumber, resultTypeOrder




/* - - - - - - not executed - - - - - - - */
/* - - - - - - not executed - - - - - - - */
/* - - - - - - not executed - - - - - - - */
return
SELECT
	vchResulted = CASE @language
		WHEN 'A' THEN REPLACE(t.vchOrderNameAfr, '*','')
		ELSE REPLACE(t.vchOrderNameEng, '*','')
	END,
	*
FROM
	RS.dbo.tblResult (NOLOCK) r
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
	r.vchPrintNumberResult = t.vchPrintNumber
AND r.chInloadsystem = t.chInloadsystem
AND	s.chDisciplineType = t.chDisciplineType
WHERE
	r.biSpecimenId = @specimenId

