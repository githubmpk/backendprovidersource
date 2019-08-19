USE ResultsPortal
GO

/******************************************************************************************************************************
Created by:		Erhard
Create date:	2019-05-23
Details:		Creating the user data model with trusted links table that references keycloak
******************************************************************************************************************************/
BEGIN TRY
	BEGIN TRANSACTION
	
	PRINT 'Creating tblUsers ...'
	IF OBJECT_ID('dbo.tblUsers') IS NULL
	BEGIN	
		CREATE TABLE tblUsers
		(		vchId			VARCHAR(50)		NOT NULL
		,		biRsId			BIGINT			NULL
		,		biInId			BIGINT			NULL
		,		biDtId			BIGINT			NULL
		,		CONSTRAINT PK_tblUsers_vchId PRIMARY KEY (vchId))

		CREATE INDEX IX_tblUsers_biDtId ON tblUsers (biDtId);
	
		IF OBJECT_ID('dbo.tblUsers') IS NULL RAISERROR('Failed to create!',16,1)

		PRINT 'Created'
	END
	ELSE
	BEGIN
		PRINT 'Not created!, exists already.'
	END

	PRINT 'Creating tblLinks ...'
	IF OBJECT_ID('dbo.tblLinks') IS NULL
	BEGIN	

		CREATE TABLE tblLinks
		(		biRsId			BIGINT		NOT NULL
		,		biTrustRsId		BIGINT		NOT NULL )

		CREATE INDEX IX_tblLinks_biRsId ON tblLinks (biRsId);

		IF OBJECT_ID('dbo.tblLinks') IS NULL RAISERROR('Failed to create!',16,1)

		PRINT 'Created'
	END
	ELSE
	BEGIN
		PRINT 'Not created!, exists already.'
	END
	        
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	DECLARE     @ErrorMessage       NVARCHAR(4000)	= ERROR_MESSAGE()
	,			@ErrorLine			INT				= ERROR_LINE()
          
	ROLLBACK TRANSACTION
    
	RAISERROR ('Script error on line %d indicating, %s (Everything rolled back)', 16, 1, @ErrorLine, @ErrorMessage)
END CATCH
GO

