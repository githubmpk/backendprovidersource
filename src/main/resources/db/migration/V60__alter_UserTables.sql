USE ResultsPortal
GO

/******************************************************************************************************************************
Created by:		Erhard
Create date:	2019-06-11
Details:		Add bSelected to tblLinks
******************************************************************************************************************************/
BEGIN TRY
	BEGIN TRANSACTION
		
	PRINT 'Change tblLinks ...'
	IF COL_LENGTH('dbo.tblLinks', 'bSelected')	IS NULL
	BEGIN
		ALTER TABLE tblLinks
		ADD			bSelected		BIT			NULL

		PRINT 'Column bSelected added'
	END
	ELSE
	BEGIN
		PRINT 'No change, bSelected exists already.'
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

