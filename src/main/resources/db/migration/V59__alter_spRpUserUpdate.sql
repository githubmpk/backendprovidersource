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
	,			@vchCallType	VARCHAR(5)		= 'V'
	,			@biRsId			BIGINT			= NULL
	,			@biInId			BIGINT			= NULL
	,			@biDtId			BIGINT			= NULL )

AS
BEGIN

	SET NOCOUNT ON

	DECLARE		@tranName		VARCHAR(20)		= 'spRpUserUpdateTran'
	
	BEGIN TRY
		BEGIN TRANSACTION @tranName

		-- --
		-- Validations
		-- --
		IF NULLIF(LTRIM(RTRIM(@vchId)),'') IS NULL
		BEGIN
			RAISERROR('Keycloak ID, required',16,1)
		END

		SELECT @vchCallType = ISNULL(RTRIM(LTRIM(UPPER(@vchCallType))),'')

		IF @vchCallType NOT IN ('V','U')
		BEGIN
			RAISERROR('Only (V)iew user or (U)pdate user allowed by [Call Type]',16,1)
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
		-- Retrun user
		-- --
		IF @vchCallType = 'V'
		BEGIN

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

		END
		        
		COMMIT TRANSACTION @tranName
	END TRY
	BEGIN CATCH
		DECLARE     @ErrorMessage       NVARCHAR(4000)	= ERROR_MESSAGE()
		,			@ErrorLine			INT				= ERROR_LINE()
          
		ROLLBACK TRANSACTION @tranName
    
		RAISERROR ('Error on line %d indicating, %s (Everything rolled back)', 16, 1, @ErrorLine, @ErrorMessage)
		
		RETURN -1
	END CATCH

	RETURN 0
END
GO

IF OBJECT_ID('dbo.spRpUserUpdate') IS NOT NULL PRINT 'Created' ELSE RAISERROR('Failed to create sp!!!',16,1)
GO