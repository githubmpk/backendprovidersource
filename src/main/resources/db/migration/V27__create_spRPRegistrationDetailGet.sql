USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPProviderSelect]    Script Date: 4/15/2019 12:43:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
2018-12-20	Precious	PP3 255		Select doctors details based on MPnumber or  mnemonic.
2019-03-15  Precious	enable search by any combination of name + surname or surname + name.
[spRPRegistrationDetailGet] 'UCTPHOPD'
**********************************************************************************************/
CREATE PROCEDURE [dbo].[spRPRegistrationDetailGet] @Search VARCHAR(20)  AS
BEGIN

SELECT TOP 1 Doctor.iId id,Doctor.vchMPNumber MPNumber,
			 ISNULL(NULLIF(dictDoctor.vchFirstName,'Not Available'),'') firstname,
			 ISNULL(NULLIF(dictDoctor.vchSurname,'Not Available'),'')  surname,
 			 dictDoctor.vchDoctorMnemonic doctorMnemonic,dictDoctor.vchEMail email,
			 ISNULL(NULLIF(dictDoctor.vchPhoneWork ,'Not Available'),'') phoneWork,
			 ISNULL(NULLIF(dictDoctor.vchPhoneMobile ,'Not Available'),'') phoneMobile,dictDoctor.vchRAMS ramsNo,
			 dictDoctor.vchPractice practice,providerLogin.iId providerId
	FROM RS.dbo.tblDoctor  Doctor
	INNER JOIN DICT.dbo.tblDoctor dictDoctor ON(dictDoctor.vchDoctorMnemonic = Doctor.vchDoctorMnemonic
												AND dictDoctor.chInloadSystem = Doctor.chInloadSystem)
	INNER JOIN RS.dbo.tblProviderLogin providerLogin ON(Doctor.vchMPNumber =providerLogin.vchMPNumber)
	--INNER JOIN RS.dbo.tblProviderLogin providerLogin ON(CASE WHEN Doctor.vchMPNumber ='' THEN SUBSTRING(providerLogin.vchMPNumber,3,20) ELSE providerLogin.vchMPNumber END
	--													 =CASE WHEN Doctor.vchMPNumber ='' THEN Doctor.iId ELSE Doctor.vchMPNumber END)
WHERE
	    (
		 dictDoctor.vchDoctorMnemonic = @Search
		  OR
		 dictDoctor.vchMPNumber  = @Search
		)
		AND Doctor.chActive='Y'
ORDER BY dictDoctor.vchFirstName,dictDoctor.vchSurname

END