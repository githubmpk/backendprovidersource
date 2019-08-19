USE [ResultsPortal]
GO

IF OBJECT_ID('dbo.spRPProviderSelect') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.spRPProviderSelect
	IF OBJECT_ID('dbo.spRPProviderSelect') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
/****** Object:  StoredProcedure [dbo].[spRPProviderSelect]    Script Date: 4/25/2019 8:56:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
Created by:		Precious
Create date:	2018-12-20
Details:		select a list a doctors matching the search parameter.
Reference		Date		Author			Description
******************************************************************************************************* */
CREATE PROCEDURE [dbo].[spRPProviderSelect] @Search VARCHAR(35)  AS
BEGIN
SET @Search=  '%'+ @Search +'%'

SELECT TOP 20 Doctor.iId id, dictDoctor.vchSurname  vchSurname,
 			--  COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+ dictDoctor.vchSurname +' '+' ('+dictDoctor.vchDoctorMnemonic+')'	doctorName,
	          dictDoctor.vchNameTitle +' - '+dictDoctor.chInloadSystem+' ('+dictDoctor.vchDoctorMnemonic+')'	doctorName,
			  dictDoctor.vchDoctorMnemonic doctorMnemonic,dictDoctor.chActive,
			  dictDoctor.vchSurname +' '+ COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+dictDoctor.vchDoctorMnemonic,
			  Doctor.vchMPNumber
	FROM RS.dbo.tblDoctor  Doctor
	INNER JOIN DICT.dbo.tblDoctor dictDoctor ON(dictDoctor.vchDoctorMnemonic = Doctor.vchDoctorMnemonic
												AND dictDoctor.chInloadSystem = Doctor.chInloadSystem)
WHERE
	    (
		 COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+ dictDoctor.vchSurname +' '+dictDoctor.vchDoctorMnemonic+'' + vchNameTitle + dictDoctor.vchName  LIKE @Search
		  OR
		 dictDoctor.vchSurname +' '+ COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+dictDoctor.vchDoctorMnemonic+''+ vchNameTitle + dictDoctor.vchName   LIKE @Search
		)
		AND Doctor.vchDoctorType NOT IN('BROKER')
ORDER BY vchNameTitle

END


