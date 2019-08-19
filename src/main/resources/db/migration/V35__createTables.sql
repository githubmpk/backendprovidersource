IF OBJECT_ID('RS.dbo.tblReportCaption ') IS NOT NULL
BEGIN
	DROP TABLE RS.dbo.tblReportCaption
END
GO
SELECT * INTO [RS].[dbo].[tblReportCaption]  FROM CPTDB4.[RS].[dbo].[tblReportCaption]


IF OBJECT_ID('RSReporting.dbo.tblRSR_Field_Names ') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_Field_Names  FROM CPTDB4.RSReporting.[dbo].tblRSR_Field_Names
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_Lab_DeltaTests') IS NOT NULL
BEGIN
DROP TABLE RSReporting.[dbo].tblRSR_Lab_DeltaTests
END
GO
SELECT * INTO RSReporting.[dbo].tblRSR_Lab_DeltaTests  FROM CPTDB4.RSReporting.[dbo].tblRSR_Lab_DeltaTests


IF OBJECT_ID('RSReporting.dbo.tblRSR_Lab_Result_Headers ') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_Lab_Result_Headers  FROM CPTDB4.RSReporting.[dbo].tblRSR_Lab_Result_Headers
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_MIC_Antibiotic_Info') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_MIC_Antibiotic_Info  FROM CPTDB4.RSReporting.[dbo].tblRSR_MIC_Antibiotic_Info
END
GO



IF OBJECT_ID('RSReporting.dbo.tblRSR_MIC_Org_Prompt_Seq') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_MIC_Org_Prompt_Seq  FROM CPTDB4.RSReporting.[dbo].tblRSR_MIC_Org_Prompt_Seq
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_MIC_Prompt_Seq') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_MIC_Prompt_Seq  FROM CPTDB4.RSReporting.[dbo].tblRSR_MIC_Prompt_Seq
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_Patient_SoftLink ') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_Patient_SoftLink  FROM CPTDB4.RSReporting.[dbo].tblRSR_Patient_SoftLink
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_PCXML_Result_Headers ') IS  NULL
BEGIN
	SELECT * INTO RSReporting.[dbo].tblRSR_PCXML_Result_Headers  FROM CPTDB4.RSReporting.[dbo].tblRSR_PCXML_Result_Headers
END
GO


IF OBJECT_ID('RSReporting.dbo.tblRSR_Test_Ord_Info ') IS  NULL
BEGIN
SELECT * INTO RSReporting.[dbo].tblRSR_Test_Ord_Info  FROM CPTDB4.RSReporting.[dbo].tblRSR_Test_Ord_Info
END
GO


IF OBJECT_ID('DICT.dbo.tblDoctorType ') IS NOT NULL
BEGIN
	DROP TABLE DICT.dbo.tblDoctorType
END
GO
SELECT * INTO DICT.[dbo].tblDoctorType  FROM CPTDB4.DICT.[dbo].tblDoctorType
GO

IF OBJECT_ID('DICT.dbo.tblTitle ') IS NOT NULL
BEGIN
	DROP TABLE DICT.dbo.tblTitle
END
GO
SELECT * INTO [DICT].[dbo].[tblTitle]  FROM CPTDB4.[DICT].[dbo].[tblTitle]
GO


