USE ResultsPortal
GO

IF OBJECT_ID('dbo.spRpUserUpdate') IS NOT NULL
BEGIN	
	DROP PROCEDURE dbo.spRpUserUpdate
	IF OBJECT_ID('dbo.spRpUserUpdate') IS NOT NULL RAISERROR('Failed to drop sp!!!',16,1) ELSE PRINT 'Dropped'
END
GO

/******************************************************************************************************************************
Created by:		Erhard
Create date:	2019-05-09
Details:		Update user from Keycloak
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2019-05-09	Erhard 			Create
******************************************************************************************************************************/
CREATE PROCEDURE spRpUserUpdate	
	(			@vchId			VARCHAR(50)
	,			@biRsId			BIGINT
	,			@biInId			BIGINT
	,			@biDtId			BIGINT )

AS
BEGIN

	BEGIN TRY
		BEGIN TRANSACTION
		-- --
		-- Validations
		-- --
		IF NULLIF(LTRIM(RTRIM(@vchId)),'') IS NULL
		BEGIN
			RAISERROR('Keycloak ID, required',16,1)
		END

		-- --
		-- Insert new kc id if not exists
		-- --
		IF NOT EXISTS ( SELECT 1 FROM tblUsers WHERE vchId = @vchId )
		BEGIN

			IF NULLIF(LTRIM(RTRIM(@biDtId)),'') IS NULL AND NULLIF(LTRIM(RTRIM(@biInId)),'') IS NULL
			BEGIN
				RAISERROR('Both dictionary and internal identifiers cannot be empty',16,1)
			END

			INSERT INTO tblUsers
			(			vchId	
			,			biRsId	
			,			biInId	
			,			biDtId )
			VALUES	  (	@vchId	
			,			@biRsId
			,			@biInId
			,			@biDtId )			

		END

		-- --
		-- Update RS doctor id first
		-- --
		UPDATE		U
		SET			biRsId							= Doctor.iId
		FROM		tblUsers					U
		JOIN		DICT.dbo.tblDoctor (NOLOCK)	dictDoctor
		ON			dictDoctor.iId					= U.biDtId
		JOIN		RS.dbo.tblDoctor (NOLOCK)	Doctor
		ON			Doctor.vchDoctorMnemonic		= dictDoctor.vchDoctorMnemonic
		AND			Doctor.chInloadSystem			= dictDoctor.chInloadSystem 
		WHERE		U.vchId							= @vchId

		-- --
		-- Update/ Insert trust links with rs id
		-- --
		CREATE TABLE #Links
		(			biRsId			BIGINT 
		,			biTrustRsId		BIGINT )

		INSERT INTO #Links
		(			biRsId
		,			biTrustRsId )
		SELECT		U.biRsId
		,			D2.iId
		FROM		tblUsers					U
		JOIN		RS.dbo.tblDoctor (NOLOCK)	D
		ON			D.iId							= U.biRsId
		JOIN		RS.dbo.tblDoctor (NOLOCK)	D2
		ON			D2.vchMPNumber					= D.vchMPNumber
		AND			D2.chInloadSystem				= D.chInloadSystem
		WHERE		U.vchId							= @vchId
		AND			U.biRsId						IS NOT NULL
		AND			NULLIF(LTRIM(RTRIM(D2.vchMPNumber)),'') IS NOT NULL

		INSERT INTO #Links
		(			biRsId
		,			biTrustRsId )
		SELECT		L.biRsId
		,			D2.iId
		FROM		#Links						L
		JOIN		RS.dbo.tblDoctor (NOLOCK)	D
		ON			D.iId							= L.biTrustRsId
		JOIN		RS.dbo.tblDoctor (NOLOCK)	D2
		ON			RIGHT(D2.vchRAMS,7)				= RIGHT(D.vchRAMS,7)
		AND			D2.chInloadSystem				= D.chInloadSystem

		-- Reload everytime - (to be changed for future custom configs)
		DELETE FROM L
		FROM		tblLinks					L
		JOIN		tblUsers					U
		ON			U.biRsId						= L.biRsId
		WHERE		U.vchId							= @vchId

		INSERT INTO tblLinks
		(			biRsId
		,			biTrustRsId )
		SELECT		DISTINCT	L.biRsId
		,						L.biTrustRsId
		FROM		#Links						L

		-- --
		-- Retrun user model and trust links union group by mp num, pr num and mnemonic
		-- --
		SELECT		U.vchId
		,			ISNULL(F.name, D.vchName)		[Name]
		,			D.vchDoctorMnemonic				[vchDoctorMnemonic]
		,			D.vchMPNumber					[vchMPNumber]
		,			RIGHT(DR.vchRAMS,7)				[vch7RAMS]
		,			U.biRsId
		,			U.biDtId
		,			U.biInId
		,			P.iId							[Pref_iId]
		,			P.vchTestProfile
		,			P.chUserLanguage
		,			P.iViewPeriod
		,			P.vchViewStatus
		,			P.chReportLayout
		,			P.bCumulativeDirection
		,			P.dtCreated						[Pref_dtCreated]
		,			P.dtModified					[Pref_dtModified]
		FROM		tblUsers					U
		LEFT JOIN	Framework.dbo.users (NOLOCK) F
		ON			F.id							= U.biInId
		LEFT JOIN	DICT.dbo.tblDoctor (NOLOCK)	D
		ON			D.iId							= U.biDtId
		LEFT JOIN	RS.dbo.tblDoctor (NOLOCK)	DR
		ON			DR.iId							= U.biRsId
		LEFT JOIN	tblUserPreferences (NOLOCK)	P
		ON			P.iUser_id						= U.vchId
		WHERE		U.vchId							= @vchId

		-- Now the links
		SELECT		'Practice'				[LinkName]
		,			RIGHT(DR.vchRAMS,7)		[LinkValue]
		FROM		tblUsers					U
		JOIN		tblLinks					L
		ON			L.biRsId						= U.biRsId		
		JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
		ON			DR.iId							= L.biTrustRsId
		WHERE		U.vchId							= @vchId
		AND			U.biRsId						IS NOT NULL
		GROUP BY	RIGHT(DR.vchRAMS,7)
		UNION ALL
		SELECT		'My Results'			[LinkName]
		,			DR.vchMPNumber			[LinkValue]
		FROM		tblUsers					U
		JOIN		tblLinks					L
		ON			L.biRsId						= U.biRsId		
		JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
		ON			DR.iId							= L.biRsId
		WHERE		U.vchId							= @vchId
		AND			U.biRsId						IS NOT NULL
		GROUP BY	DR.vchMPNumber
		UNION ALL
		SELECT		MAX(DR.vchName)			[LinkName]
		,			DR.vchDoctorMnemonic	[LinkValue]
		FROM		tblUsers					U
		JOIN		tblLinks					L
		ON			L.biRsId						= U.biRsId		
		JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
		ON			DR.iId							= L.biTrustRsId
		WHERE		U.vchId							= @vchId
		AND			U.biRsId						IS NOT NULL
		GROUP BY	DR.vchDoctorMnemonic
        
		-- --
		-- Cleanup
		-- --
		DROP TABLE #Links
		        
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE     @ErrorMessage       NVARCHAR(4000)	= ERROR_MESSAGE()
		,			@ErrorLine			INT				= ERROR_LINE()
          
		ROLLBACK TRANSACTION
    
		RAISERROR ('Error on line %d indicating, %s (Everything rolled back)', 16, 1, @ErrorLine, @ErrorMessage)
		RETURN -1
	END CATCH

	RETURN 0
END
GO

IF OBJECT_ID('dbo.spRpUserUpdate') IS NOT NULL PRINT 'Created' ELSE RAISERROR('Failed to create sp!!!',16,1)
GO