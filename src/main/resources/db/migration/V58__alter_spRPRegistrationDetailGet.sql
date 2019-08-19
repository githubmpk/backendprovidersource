USE ResultsPortal
GO

IF OBJECT_ID('dbo.spRpRegistrationDetailGet') IS NOT NULL
BEGIN	
	DROP PROCEDURE dbo.spRpRegistrationDetailGet
	IF OBJECT_ID('dbo.spRpRegistrationDetailGet') IS NOT NULL RAISERROR('Failed to drop sp!!!',16,1) ELSE PRINT 'Dropped'
END
GO

/******************************************************************************************************************************
Created by:		Precious
Create date:	2018-12-20
Details:		Return unregistred users
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2018-12-20	Precious		PP3 255 Select doctors details based on MPnumber or  mnemonic.
				2019-03-15  Precious		enable search by any combination of name + surname or surname + name.
				2019-05-09	Erhard 			Remove provider practice and add already registred and all entity checks
******************************************************************************************************************************/
CREATE PROCEDURE spRpRegistrationDetailGet	
	(			@vchSearch			VARCHAR(50)	)

AS
BEGIN

	DECLARE		@nvchUsername		NVARCHAR(510)

	-- --
	-- Check on Keycloak first
	-- --
	SELECT		@nvchUsername		= U.USERNAME
	FROM		Keycloak.dbo.USER_ENTITY (NOLOCK) U
	WHERE		U.REALM_ID			= 'pathcare'
	AND			U.USERNAME			= @vchSearch

	IF @nvchUsername IS NOT NULL
	BEGIN

		SELECT		E.ID									[id]
		,			DD.vchMPNumber							[MPNumber]
		,			ISNULL(FU.name, E.FIRST_NAME)			[firstname]
		,			E.LAST_NAME								[surname]
		, 			DD.vchDoctorMnemonic					[doctorMnemonic]
		,			E.EMAIL									[email]
		,			NULL									[phoneWork]
		,			NULL									[phoneMobile]
		,			NULL									[ramsNo]
		,			NULL									[practice]
		,			NULL									[providerId]
		,			U.biRsId								[RsId]
		,			U.biInId								[InId]
		,			U.biDtId								[DtId]
		,			E.USERNAME								[kcUser]
		FROM		Keycloak.dbo.USER_ENTITY (NOLOCK)	E
		JOIN		tblUsers							U
		ON			U.vchId									= E.ID
		LEFT JOIN	Framework.dbo.users (NOLOCK)		FU
		ON			FU.id									= U.biInId
		LEFT JOIN	DICT.dbo.tblDoctor (NOLOCK)			DD
		ON			DD.iId									= U.biDtId
		WHERE		E.REALM_ID								= 'pathcare'
		AND			E.USERNAME								= @nvchUsername

	END
	ELSE
	BEGIN
		-- --
		-- Else, look for new intranet users to register
		-- --
		SELECT		@nvchUsername			= U.username
		FROM		Framework.dbo.users (NOLOCK) U
		WHERE		U.username				= @vchSearch
		AND			U.isActive				= 1

		IF @nvchUsername IS NOT NULL
		BEGIN

			SELECT		CONVERT(VARCHAR(50),U.id)	[id]
			,			NULL						[MPNumber]
			,			U.name						[firstname]
			,			NULL						[surname]
			, 			NULL						[doctorMnemonic]
			,			U.email						[email]
			,			NULL						[phoneWork]
			,			NULL						[phoneMobile]
			,			NULL						[ramsNo]
			,			NULL						[practice]
			,			NULL						[providerId]
			,			NULL						[RsId]
			,			U.id						[InId]
			,			NULL						[DtId]
			,			NULL						[kcUser]
			FROM		Framework.dbo.users (NOLOCK) U
			WHERE		U.username				= @vchSearch
			AND			U.isActive				= 1

		END
		ELSE
		BEGIN
			-- --
			-- Else, search for other registered Mnemonics under MpNumber and return recodrs, or else find all new and retrun it.
			-- --
			IF EXISTS	  (	SELECT		1
							FROM		tblUsers (NOLOCK) U
							WHERE		U.biDtId			IN (SELECT		dictDoctor.iId
																FROM		DICT.dbo.tblDoctor (NOLOCK)	dictDoctor
																WHERE    (	dictDoctor.vchDoctorMnemonic	= @vchSearch
																		OR	dictDoctor.vchMPNumber			= @vchSearch )
																AND			dictDoctor.chActive				= 'Y') )
			BEGIN

				SELECT		E.ID							[id]
				,			dictDoctor.vchMPNumber			[MPNumber]
				,			E.FIRST_NAME					[firstname]
				,			E.LAST_NAME						[surname]
				, 			dictDoctor.vchDoctorMnemonic	[doctorMnemonic]
				,			E.EMAIL							[email]
				,			NULL							[phoneWork]
				,			NULL							[phoneMobile]
				,			NULL							[ramsNo]
				,			NULL							[practice]
				,			NULL							[providerId]
				,			U.biRsId						[RsId]
				,			U.biInId						[InId]
				,			U.biDtId						[DtId]
				,			E.USERNAME						[kcUser]
				FROM		DICT.dbo.tblDoctor (NOLOCK)		dictDoctor
				JOIN		tblUsers (NOLOCK)				U
				ON			U.biDtId						= dictDoctor.iId
				JOIN		Keycloak.dbo.USER_ENTITY (NOLOCK)	E
				ON			E.ID							= U.vchId
				WHERE    (	dictDoctor.vchDoctorMnemonic	= @vchSearch
						OR	dictDoctor.vchMPNumber			= @vchSearch )
				AND			dictDoctor.chActive				= 'Y'

				IF @@ROWCOUNT <= 0
				BEGIN
					RAISERROR('The link between the dictionary doctor records and the user data model linking to Keycloak failed!',16,1)
				END

			END
			ELSE
			BEGIN

				SELECT		CONVERT(VARCHAR(50),dictDoctor.iId)								[id]
				,			dictDoctor.vchMPNumber											[MPNumber]
				,			ISNULL(NULLIF(dictDoctor.vchFirstName,'Not Available'),'')		[firstname]
				,			ISNULL(NULLIF(dictDoctor.vchSurname,'Not Available'),'')		[surname]
				, 			dictDoctor.vchDoctorMnemonic									[doctorMnemonic]
				,			dictDoctor.vchEMail												[email]
				,			ISNULL(NULLIF(dictDoctor.vchPhoneWork ,'Not Available'),'')		[phoneWork]
				,			ISNULL(NULLIF(dictDoctor.vchPhoneMobile ,'Not Available'),'')	[phoneMobile]
				,			dictDoctor.vchRAMS												[ramsNo]
				,			dictDoctor.vchPractice											[practice]
				,			NULL															[providerId]
				,			Doctor.iId														[RsId]
				,			NULL															[InId]
				,			dictDoctor.iId													[DtId]
				,			NULL															[kcUser]
				FROM		DICT.dbo.tblDoctor (NOLOCK)	dictDoctor
				LEFT JOIN	RS.dbo.tblDoctor (NOLOCK)	Doctor
				ON			Doctor.vchDoctorMnemonic		= dictDoctor.vchDoctorMnemonic
				AND			Doctor.chInloadSystem			= dictDoctor.chInloadSystem 
				WHERE    (	dictDoctor.vchDoctorMnemonic	= @vchSearch
						OR	dictDoctor.vchMPNumber			= @vchSearch
						OR	Doctor.vchMPNumber				= @vchSearch )
				AND			dictDoctor.chActive				= 'Y'
				AND			ISNULL(Doctor.chActive,'Y')		= 'Y'
				ORDER BY	dictDoctor.vchFirstName,dictDoctor.vchSurname

			END
		END
	END

	RETURN 0
END
GO

IF OBJECT_ID('dbo.spRpRegistrationDetailGet') IS NOT NULL PRINT 'Created' ELSE RAISERROR('Failed to create sp!!!',16,1)
GO