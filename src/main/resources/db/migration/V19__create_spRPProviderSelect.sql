USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPProviderSelect]    Script Date: 4/3/2019 10:50:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
2018-12-20	Precious	PAT 101		select a list a doctors matching the search parameter.
2019-03-15  Precious				enable search by any combination of name + surname or surname + name.
spRPProviderSelect 'VERNON LOU'
**********************************************************************************************/
CREATE PROCEDURE [dbo].[spRPProviderSelect] @Search VARCHAR(35)  AS
BEGIN

SET @Search=  '%'+ @Search +'%'

SELECT TOP 10 Doctor.iId id, dictDoctor.vchSurname  vchSurname,
 			  COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+ dictDoctor.vchSurname +' '+' ('+dictDoctor.vchDoctorMnemonic+')'	doctorName,
	          dictDoctor.vchDoctorMnemonic doctorMnemonic,dictDoctor.chActive,
			  dictDoctor.vchSurname +' '+ COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+dictDoctor.vchDoctorMnemonic,
			  Doctor.vchMPNumber
	FROM RS.dbo.tblDoctor  Doctor
	INNER JOIN DICT.dbo.tblDoctor dictDoctor ON(dictDoctor.vchDoctorMnemonic = Doctor.vchDoctorMnemonic
												AND dictDoctor.chInloadSystem = Doctor.chInloadSystem)
WHERE
	    (
		 COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+ dictDoctor.vchSurname +' '+dictDoctor.vchDoctorMnemonic+'' + Doctor.vchMPNumber   LIKE @Search
		  OR
		 dictDoctor.vchSurname +' '+ COALESCE(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') +' '+dictDoctor.vchDoctorMnemonic+'' + Doctor.vchMPNumber   LIKE @Search
		)
		AND Doctor.chActive='Y'
ORDER BY dictDoctor.vchFirstName,dictDoctor.vchSurname

END