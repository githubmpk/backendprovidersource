USE ResultsPortal
GO

IF OBJECT_ID('dbo.spRpUserLinks') IS NOT NULL
BEGIN	
	DROP PROCEDURE dbo.spRpUserLinks
	IF OBJECT_ID('dbo.spRpUserLinks') IS NOT NULL RAISERROR('Failed to drop sp!!!',16,1) ELSE PRINT 'Dropped'
END
GO

/******************************************************************************************************************************
Created by:		Erhard
Create date:	2019-05-09
Details:		Create and return trusted links
Reference		Date		Author			Description
--------------	----------	--------------	-----------------------------------------------------------------------------------
				2019-05-09	Erhard 			Create
******************************************************************************************************************************/
CREATE PROCEDURE spRpUserLinks	
	(			@vchId			VARCHAR(50) 
	,			@bReset			BIT			= 1 )

AS
BEGIN

	SET NOCOUNT ON

	DECLARE		@tranName		VARCHAR(20)		= 'spRpUserLinksTran'
	
	BEGIN TRY
		BEGIN TRANSACTION @tranName

		-- --
		-- Validations
		-- --
		IF NULLIF(LTRIM(RTRIM(@vchId)),'') IS NULL
		BEGIN
			RAISERROR('Keycloak ID, required',16,1)
		END

		-- --
		-- Update/ Insert trust links with rs id
		-- --
		CREATE TABLE #Links
		(			biRsId			BIGINT 
		,			biTrustRsId		BIGINT
		,			bSelected		BIT )

		-- --
		-- Defualt reset or first time load
		-- --
		IF ISNULL(@bReset, 1) = 1 OR NOT EXISTS   (	SELECT		1
													FROM		tblUsers					U
													JOIN		tblLinks					L
													ON			L.biRsId						= U.biRsId		
													WHERE		U.vchId							= @vchId
													AND			U.biRsId						IS NOT NULL )
		BEGIN

			INSERT INTO #Links
			(			biRsId
			,			biTrustRsId
			,			bSelected )
			SELECT		U.biRsId
			,			D2.iId
			,			1
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
			AND			D2.iId							<> L.biTrustRsId

			-- Reset and reload
			DELETE FROM L
			FROM		tblLinks					L
			JOIN		tblUsers					U
			ON			U.biRsId						= L.biRsId
			WHERE		U.vchId							= @vchId

			INSERT INTO tblLinks
			(			biRsId
			,			biTrustRsId
			,			bSelected )
			SELECT		DISTINCT	L.biRsId
			,						L.biTrustRsId
			,						L.bSelected
			FROM		#Links						L

		END

		-- --
		-- Return links
		-- --
		SELECT		ROW_NUMBER() OVER (ORDER BY OutTbl.OrderType, OutTbl.LinkName, OutTbl.LinkValue)		[id]
		,			OutTbl.LinkName
		,			OutTbl.LinkValue
		,			OutTbl.Selected
		FROM	  (	SELECT		2						[OrderType]
					,			'Practice'				[LinkName]
					,			RIGHT(DR.vchRAMS,7)		[LinkValue]
					,			(CASE WHEN COUNT(1) = SUM(CONVERT(INT, ISNULL(L.bSelected,0))) THEN 1 ELSE 0 END)		[Selected]
					FROM		tblUsers					U
					JOIN		tblLinks					L
					ON			L.biRsId						= U.biRsId		
					JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
					ON			DR.iId							= L.biTrustRsId
					WHERE		U.vchId							= @vchId
					AND			U.biRsId						IS NOT NULL
					GROUP BY	RIGHT(DR.vchRAMS,7)
					UNION ALL
					SELECT		1						[OrderType]
					,		  (	CASE WHEN D.vchMPNumber	= DR.vchMPNumber THEN 'My Results' ELSE 'MPNumber' END )		[LinkName]
					,			DR.vchMPNumber			[LinkValue]
					,			(CASE WHEN COUNT(1) = SUM(CONVERT(INT, ISNULL(L.bSelected,0))) THEN 1 ELSE 0 END)		[Selected]
					FROM		tblUsers					U
					JOIN		RS.dbo.tblDoctor (NOLOCK)	D
					ON			D.iId							= U.biRsId
					JOIN		tblLinks					L
					ON			L.biRsId						= U.biRsId		
					JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
					ON			DR.iId							= L.biTrustRsId
					WHERE		U.vchId							= @vchId
					AND			U.biRsId						IS NOT NULL
					GROUP BY  (	CASE WHEN D.vchMPNumber	= DR.vchMPNumber THEN 'My Results' ELSE 'MPNumber' END ), DR.vchMPNumber
					UNION ALL
					SELECT		3						[OrderType]
					,			MAX(DR.vchName)			[LinkName]
					,			DR.vchDoctorMnemonic	[LinkValue]
					,			(CASE WHEN COUNT(1) = SUM(CONVERT(INT, ISNULL(L.bSelected,0))) THEN 1 ELSE 0 END)		[Selected]
					FROM		tblUsers					U
					JOIN		tblLinks					L
					ON			L.biRsId						= U.biRsId		
					JOIN		RS.dbo.tblDoctor (NOLOCK)	DR
					ON			DR.iId							= L.biTrustRsId
					WHERE		U.vchId							= @vchId
					AND			U.biRsId						IS NOT NULL
					GROUP BY	DR.vchDoctorMnemonic ) AS OutTbl
		-- --
		-- Cleanup
		-- --
		DROP TABLE #Links
		        
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

IF OBJECT_ID('dbo.spRpUserLinks') IS NOT NULL PRINT 'Created' ELSE RAISERROR('Failed to create sp!!!',16,1)
GO