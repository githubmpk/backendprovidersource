USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportFooter]    Script Date: 4/3/2019 10:39:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportFooter]  @specimenId BIGINT
AS
BEGIN

	SET NOCOUNT ON

	SELECT SpecimenComment.vchComment
					FROM RS.dbo.tblSpecimenCommentLink (NOLOCK)  SpecimenCommentLink
						INNER JOIN RS.dbo.tblSpecimenComment (NOLOCK)  SpecimenComment ON (SpecimenComment.iId = SpecimenCommentLink.iSpecimenCommentId)
					WHERE SpecimenCommentLink.biSpecimenId = @specimenId
						AND SpecimenCommentLink.chTag = 'Z'
						AND SpecimenComment.vchComment IS NOT NULL
						AND SpecimenComment.vchComment NOT IN('','~')
						ORDER BY chTag, siOrder
	END