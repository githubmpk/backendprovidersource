USE [ResultsPortal]
GO
/****** Object:  StoredProcedure [dbo].[spRPAuditAdd]    Script Date: 4/3/2019 10:48:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* *******************************************************************************************************
20-02-2019   Precious     Log Activity on PathProvider3
******************************************************************************************************* */
CREATE PROCEDURE  [dbo].[spRPAuditAdd]   @vchApplication VARCHAR(200),
                                                               @vchDetail VARCHAR(100),
                                                               @vchIPAddress VARCHAR(20),
                                                               @biPatientId BIGINT,
                                                               @vchProcess VARCHAR(50),
                                                               @vchUsername VARCHAR(50),
                                                               @biSpecimenId BIGINT,
                                                               @vchStoredProc VARCHAR(1000),
                                                               @biRequisitionId BIGINT AS
BEGIN

       INSERT INTO RS.dbo.tblPPAudit (vchApplication,dtCreate,vchDetail,vchIPAddress,biPatientId ,vchProcess,vchUsername,biSpecimenId ,vchStoredProc,biRequisitionId)
             VALUES (@vchApplication, GETDATE(), @vchDetail, @vchIPAddress, @biPatientId , @vchProcess, @vchUsername, @biSpecimenId, @vchStoredProc,@biRequisitionId)


END