   USE [ResultsPortal]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_XML_Result_Comment]    Script Date: 4/3/2019 10:52:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_XML_Result_Comment] (@biSpecimenId BIGINT)

RETURNS  @ResComment TABLE  (ResId BIGINT, Comment VARCHAR(MAX),chTagSort CHAR )  AS  BEGIN

DECLARE  @biResultId BIGINT, @vchComments VARCHAR(MAX)= '',@vchComment VARCHAR(MAX) ='',
         @ResultCount BIGINT,@biResultId1 BIGINT,  @chTagSort CHAR,@siOrder INT

 DECLARE c1 CURSOR FOR
   		SELECT COUNT(Result.biid)countRes, Result.biId,
				ResultCommentLink.chTag
		FROM RS.dbo.tblResult (NOLOCK) Result
			INNER JOIN RS.dbo.tblResultCommentLink (NOLOCK) ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
			INNER JOIN RS.dbo.tblResultComment (NOLOCK) ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
		WHERE Result.biSpecimenId = @biSpecimenId
		GROUP BY  Result.biId,ResultCommentLink.chTag

         OPEN c1

         FETCH NEXT FROM c1 INTO   @ResultCount,@biResultId1 ,@chTagSort

         WHILE @@FETCH_STATUS = 0
         BEGIN

         DECLARE c2 CURSOR FOR
  		 SELECT DISTINCT
			ResultComment.vchComment,siOrder
			FROM RS.dbo.tblResult (NOLOCK) Result
			INNER JOIN RS.dbo.tblResultCommentLink (NOLOCK) ResultCommentLink ON (Result.biId = ResultCommentLink.biResultId )
			INNER JOIN RS.dbo.tblResultComment (NOLOCK) ResultComment ON (ResultComment.iId = ResultCommentLink.iResultCommentId )
			 WHERE Result.biSpecimenId = @biSpecimenId   AND   Result.biId = @biResultId1  AND ResultComment.vchComment NOT LIKE '@%'
						AND   ResultCommentLink.chtag= @chTagSort
						 AND ISNULL(ResultComment.vchComment,'')<>''
			 ORDER BY  siOrder
            OPEN c2
            FETCH NEXT FROM c2 INTO   @vchComment,@siOrder
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @vchComments = @vchComments + ' ' + @vchComment + CHAR(13) + CHAR(10)
                FETCH NEXT FROM c2 INTO   @vchComment,@siOrder
            END
               INSERT INTO @ResComment VALUES(@biResultId1,@vchComments,@chTagSort)
                SET @vchComments = ''
               CLOSE c2
               DEALLOCATE c2
               FETCH NEXT FROM c1 INTO   @ResultCount ,@biResultId1 , @chTagSort
         END
            CLOSE c1
               DEALLOCATE c1
	RETURN

END