USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spReportResultMicroSensComment]    Script Date: 4/3/2019 10:46:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReportResultMicroSensComment]  @biSpecimenId BIGINT
														 AS
BEGIN

	SET NOCOUNT ON

	;WITH cteOrganismComment (biMicroId, vchComment, siMicroOrder, tiMicroType) AS
			(SELECT DISTINCT Micro.biId,
					MicroResultComment.vchComment,
   					MicroResultCommentLink.siOrder,
					MicroResultCommentLink.tiMicroType
				FROM RS.dbo.tblMicro (NOLOCK) Micro
					inner  JOIN RS.dbo.tblMicroResultCommentLink (NOLOCK) MicroResultCommentLink ON (MicroResultCommentLink.biMicroId = Micro.biId)
 					inner  JOIN RS.dbo.tblResultComment (NOLOCK) MicroResultComment ON (MicroResultCommentLink.iResultCommentId = MicroResultComment.iId)
				WHERE biSpecimenId = @biSpecimenId
	)

	SELECT DISTINCT  Result.vchPrintNumberResult vchPrintNumberResultSort,
			OrganismComment.vchComment vchMicroComment,
   			OrganismComment.siMicroOrder,
			OrganismComment.tiMicroType,
			Result.iPrintOrder

	FROM RS.dbo.tblResult (NOLOCK) Result
			INNER JOIN RS.dbo.tblMicro (NOLOCK) Micro ON ( Micro.biResultId = Result.biId)
			Inner JOIN cteOrganismComment AS OrganismComment ON (Micro.biId = OrganismComment.biMicroId
									and tiMicroType = 2)

	WHERE Result.biSpecimenId = @biSpecimenId

	ORDER BY vchprintnumberResultSort, tiMicroType, siMicroOrder
END