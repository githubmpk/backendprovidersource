USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spRpReportHtmlResultLab') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spRpReportHtmlResultLab
	IF OBJECT_ID('dbo.spRpReportHtmlResultLab') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  StoredProcedure [dbo].[spRpReportHtmlResultLab]    Script Date: 2019/05/14 9:05:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************************
Created by:		PvNiekerk
Create date:	2019-05-10
Details:		Build up HTML results display.
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2019-05-10	PvNiekerk		Create
******************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpReportHtmlResultLab]
--declare
@patientId bigint,
@requisitionId bigint,
@specimenId bigint,
@drMnemonic varchar(15),
@language char(1)

AS

--set @patientId = 10641680
--set @requisitionId = 32251813
--set @specimenId = 56877059
--set @DrMnemonic = 'LOUVP0'
--set @language = 'E'

BEGIN

	SET NOCOUNT ON;

	DECLARE
		@html varchar(MAX)

	/*
	-- TEMP HTML
	SET @html = '<table style="width:100%; font-size: 9pt;">'
	SET @html += '<tr><td><b>Requisition No:</b></td><td colspan="3">007</td></tr>';
	SET @html += '<tr><td><b>Specimen No:</b></td><td colspan="2">007/01</td><td style="text-align:center; color: black; border:solid 0.5pt black;"><b>TBA</b></td></tr>';
	SET @html += '<tr><td><b>Patient:</b></td><td colspan="3" style="border: solid 0.5pt silver;">PvNiekerk</td></tr>';
	SET @html += '<tr><td><b>Patient ID no:</b></td><td colspan="2">760723<br></td><td><b>Gender:</b>M</td></tr>';

	SET @html += '<tr style="background-color: #003399; color: white;">' +
					'<td><b>Test</b></td>' +
					'<td style="text-align: center;"><b>Result</b></td>' +
					'<td style="text-align: center;"><b>Flag</b></td>' +
					'<td><b>Reference Range</b></td>' +
				 '</tr>';

	SET @html += '<tr style="background-color: transparent;">' +
					'<td style="width:40%;">TEST 1</td>' +
					'<td style="width:25%; text-align: center;">100</td>' +
					'<td style="width:5%; color: black; font-weight: normal; text-align: center;">&nbsp;</td>' +
					'<td style="width:30%;">90-110</td>' +
				 '</tr>';

	SET @html += '</table>';

	select 1 as id, @html as html

	RETURN
	*/

	DECLARE @temp TABLE (
		Proc_ID varchar(50),
		Proc_Seq1 varchar(50),
		Proc_Seq2 varchar(50),
		Proc_Seq3 varchar(50),
		vchOrderTestName varchar(100),
		vchReportTestName varchar(100),
		vchResult varchar(100),
		vchAbnormalFlag varchar(100),
		vchReference varchar(100),
		vchPrintNumberResult varchar(100),
		vchPrintNumberOrder varchar(100),
		Comment varchar(100),
		siOrder varchar(100)
	)

	INSERT INTO @temp
	EXEC [dbo].[spReportResultLab] @patientId, @requisitionId, @specimenId, @DrMnemonic, @language

	DECLARE
		@prompt varchar(100),
		@result varchar(100),
		@vchAbnormalFlag varchar(50),
		@vchNormalRange varchar(50),

		@vchRequisitionNumber varchar(50),
		@vchStatus varchar(50),
		@vchSpecimenNumber varchar(50),
		@patientFullName varchar(100),
		@vchPatID varchar(100),
		@chPatGender char(1),

		@backgroundColor varchar(50),
		@textColor varchar(50),
		@fontWeight varchar(50),
		@count int,
		@headeradded bit

	--SELECT * FROM MSSQL.RS.dbo.tblRequisition WHERE biId = @requisitionId
	--SELECT * FROM MSSQL.RS.dbo.tblSpecimen WHERE biId = @specimenId
	--SELECT * FROM MSSQL.RS.dbo.tblPatient WHERE biId = 10517184 --@patientId
	SELECT @patientFullName = vchPatTitle + ' ' + vchPatFirstName + ' ' + vchPatSurname, @vchPatID = vchPatID, @chPatGender = chPatGender FROM RS.dbo.tblPatient WHERE biId = @patientId
	SELECT @vchSpecimenNumber = vchSpecimenNumber, @vchStatus = vchStatus FROM RS.dbo.tblSpecimen WHERE biId = @specimenId
	SELECT @vchRequisitionNumber = vchRequisitionNumber FROM RS.dbo.tblRequisition WHERE biId = @requisitionId

	SET @html = '<table style="width:100%; font-size: 9pt;">'
	SET @html += '<tr><td><b>Requisition No:</b></td><td colspan="3">' + @vchRequisitionNumber + '</td></tr>';
	SET @html += '<tr><td><b>Specimen No:</b></td><td colspan="2">' + @vchSpecimenNumber + '</td><td style="text-align:center; color:' + CASE @vchStatus WHEN 'COMP' THEN 'green' WHEN 'P' THEN 'red' END + '; border:solid 0.5pt ' + CASE @vchStatus WHEN 'COMP' THEN 'green' WHEN 'P' THEN 'red' END + ';"><b>' + @vchStatus + '</b></td></tr>';
	SET @html += '<tr><td><b>Patient:</b></td><td colspan="3" style="border: solid 0.5pt silver;">' + @patientFullName + '</td></tr>';
	SET @html += '<tr><td><b>Patient ID no:</b></td><td colspan="2">' + @vchPatID + '<br></td><td><b>Gender:</b> ' + @chPatGender + '</td></tr>';

	set @count = 0
	set @headeradded = 0
	DECLARE result_cursor CURSOR FOR
	SELECT
		[vchReportTestName],
		[vchResult],
		[vchAbnormalFlag],
		[vchReference]
	FROM
		@temp

	--EXEC MSSQL.ResultsPortal.dbo.spReportResultLab @patientId, @requisitionId, @specimenId, @DrMnemonic, @language;


	OPEN result_cursor

	FETCH NEXT FROM result_cursor
	INTO @prompt, @result, @vchAbnormalFlag, @vchNormalRange

	WHILE @@FETCH_STATUS = 0
	BEGIN

		--PRINT @result
		IF @count = 0 AND @headeradded = 0
		BEGIN
			SET @html += '<tr style="background-color: #003399; color: white;">' +
							'<td style="width:40%;"><b>Test</b></td>' +
							'<td style="width:25%; text-align: center;"><b>Result</b></td>' +
							'<td style="width: 5%; text-align: center;"><b>Flag</b></td>' +
							'<td style="width:30%;"><b>Reference Range</b></td>' +
						 '</tr>';

			SET @headeradded = 1
		END

		SET @backgroundColor = CASE WHEN @count % 2 = 0 THEN 'transparent' ELSE 'whitesmoke' END
		SET @textColor = 'black';
		SET @fontWeight = 'normal';
		IF LTRIM(RTRIM(ISNULL(@vchAbnormalFlag, ''))) = 'L'
			BEGIN
				SET @textColor = 'blue'
				SET @fontWeight = 'bold'
			END
			ELSE IF LTRIM(RTRIM(ISNULL(@vchAbnormalFlag, ''))) = 'H'
			BEGIN
				SET @textColor = 'red'
				SET @fontWeight = 'bold'
			END

		SET @html += '<tr style="background-color: ' + @backgroundColor + ';">' +
						'<td>' + @prompt + '</td>' +
						'<td style="text-align: center;">' + @result + '</td>' +
						'<td style="color:' + @textColor + '; font-weight:' + @fontWeight + '; text-align: center;">' + ISNULL(@vchAbnormalFlag, '') + '</td>' +
						'<td>' + REPLACE(REPLACE(ISNULL(@vchNormalRange, '&nbsp;'), '<', '&lt;'), '>', '&gt;') + '</td>' +
					 '</tr>';

		SET @count = @count + 1

		FETCH NEXT FROM result_cursor
		INTO @prompt, @result, @vchAbnormalFlag, @vchNormalRange
	END
	CLOSE result_cursor;
	DEALLOCATE result_cursor;

	SET @html += '</table>';

	select 1 as id, @html as html

END