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
/****** Object:  StoredProcedure [dbo].[spReportCaption]    Script Date: 5/23/2019 12:10:08 PM ******/
SET ANSI_NULLS ON
GO

/* *******************************************************************************************************
16-04-2019	Precious	select data for single report header
spReportCaption 9613767,27660240
spReportCaption 10641680,32251813
spReportCaption 32339237
spReportCaptionPM 9155838
******************************************************************************************************* */
 CREATE PROC [dbo].[spReportCaption] @requisitionId BIGINT


AS
BEGIN
	DECLARE @DocLanguage CHAR(1),
			@captionType CHAR(20),
			@cols AS NVARCHAR(MAX),
			@query  AS NVARCHAR(MAX)

	SELECT  TOP 1 @DocLanguage=Doctor.chLanguage,
				@captionType = COALESCE(NULLIF(vchReportFields,''),'standard')
		FROM RS.dbo.tblDoctor (NOLOCK) Doctor
			INNER JOIN DICT.dbo.tblDoctor (NOLOCK)  dictDoctor ON(dictDoctor.vchDoctorMnemonic=Doctor.vchDoctorMnemonic
														AND dictDoctor.chInloadSystem=Doctor.chInloadSystem)
			LEFT OUTER JOIN DICT.dbo.tblDoctorType (NOLOCK)  dictDoctorType ON(dictDoctor.vchDoctorType=dictDoctorType.vchDoctorType
																		AND dictDoctor.chInloadSystem=dictDoctorType.chInloadSystem)
			INNER JOIN RS.dbo.tblDoctorRequisition (NOLOCK) DoctorRequisition ON (Doctor.iId=DoctorRequisition.iDoctorId
																				AND Doctor.chInloadSystem=DoctorRequisition.chInloadSystem)
		WHERE DoctorRequisition.biRequisitionId=@requisitionId
				AND DoctorRequisition.chReportType='R'

SELECT  @cols = STUFF((SELECT ',' + QUOTENAME(vchfieldName)
                    FROM [RS].[dbo].[tblReportCaption]
					WHERE vchCaptionType = @captionType
                   FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)')
				,1,1,'')

	SET @query = N'SELECT ' + @cols + N' from
				 (
					SELECT CASE WHEN '''+ @DocLanguage +'''=''A'' THEN vchAfrikaans ELSE vchEnglish END caption,vchfieldName
					FROM [RS].[dbo].[tblReportCaption] (NOLOCK)  WHERE vchCaptionType = '''+@captionType+'''
				) pivotTable
				pivot
				(
					max(caption)
					for vchfieldName in (' + @cols + N')
				) p '

   EXEC sp_executesql @query;

END