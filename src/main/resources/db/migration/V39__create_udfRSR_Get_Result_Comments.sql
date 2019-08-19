USE [RSReporting]
GO
IF OBJECT_ID('dbo.udfRSR_Get_Result_Comments') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udfRSR_Get_Result_Comments
	IF OBJECT_ID('dbo.udfRSR_Get_Result_Comments') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  UserDefinedFunction [dbo].[udfRSR_Get_Result_Comments]    Script Date: 5/22/2019 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udfRSR_Get_Result_Comments] (@ResId BIGINT)
RETURNS VARCHAR(MAX)  AS

BEGIN

DECLARE  @OutComm VARCHAR(MAX),
         @InComm VARCHAR(200),
		 @Corder INT

SET @OutComm = ''

 DECLARE c1 CURSOR FOR
   		SELECT DISTINCT TOP 9999999 siOrder,CONCAT('          ',ResultComment.vchComment,(CASE WHEN COALESCE(vchDescription,'')<>'' THEN ' - ' +vchDescription END))+CHAR(10)
		FROM RS.dbo.tblResult (NOLOCK) Result
			INNER JOIN RS.dbo.tblResultCommentLink (NOLOCK) ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
			INNER JOIN RS.dbo.tblResultComment     (NOLOCK) ResultComment     ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
			LEFT OUTER JOIN  RS.dbo.tblICD10       (NOLOCK) ICD10             ON (ICD10.vchCode=ResultComment.vchComment)
		WHERE Result.biId = @ResId
		AND ResultComment.vchComment IS NOT NULL
		AND LEFT(ResultComment.vchComment,1)<>'@'
		ORDER BY  siOrder

         OPEN c1

         FETCH NEXT FROM c1 INTO   @Corder,@InComm

         WHILE @@FETCH_STATUS = 0
         BEGIN

                SET @OutComm = @OutComm + @InComm

          FETCH NEXT FROM c1 INTO  @Corder,@InComm
          END
          CLOSE c1
          DEALLOCATE c1

	RETURN @OutComm

END




