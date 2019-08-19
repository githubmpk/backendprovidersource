USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPAuditAdd]    Script Date: 2019/04/12 08:37:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
20-02-2019   Precious     Log Activity on PathProvider3
******************************************************************************************************* */
ALTER PROCEDURE  [dbo].[spRPAuditAdd]   @vchApplication VARCHAR(200),
                                                               @vchDetail VARCHAR(MAX),
                                                               @vchIPAddress VARCHAR(20),
                                                               @biPatientId BIGINT,
                                                               @vchProcess VARCHAR(50),
                                                               @vchUsername VARCHAR(50),
                                                               @biSpecimenId BIGINT,
                                                               @vchStoredProc VARCHAR(500),
                                                               @biRequisitionId BIGINT,
															   @vchBrowser VARCHAR(100) = '' AS
BEGIN

       INSERT INTO RS.dbo.tblPPAudit (vchApplication,dtCreate,vchDetail,vchIPAddress,biPatientId ,vchProcess,vchUsername,biSpecimenId ,vchStoredProc,biRequisitionId,vchBrowser)
             VALUES (@vchApplication, GETDATE(), @vchDetail, @vchIPAddress, @biPatientId , @vchProcess, @vchUsername, @biSpecimenId, @vchStoredProc,@biRequisitionId,@vchBrowser)


END