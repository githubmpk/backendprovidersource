USE [ResultsPortal]
GO
IF OBJECT_ID('dbo.dfReportResultsMicro') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.dfReportResultsMicro
	IF OBJECT_ID('dbo.dfReportResultsMicro') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
/****** Object:  UserDefinedFunction [dbo].[udfReportResultsMicro]    Script Date: 5/22/2019 10:31:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udfReportResultsMicro] (@SpcID BIGINT) 
RETURNS

 @Results TABLE(
	[Res_Type]            [varchar](1) NOT NULL,
    [Sort_Seq1]           [varchar](64) NOT NULL,
	[Sort_Seq2]           [varchar](64) NOT NULL,
	[Res_Seq]             [varchar](4) NULL,
	[Test_Set_ID]         [varchar](32) NOT NULL,
	[Test_Set_Code]       [varchar](32) NOT NULL,
	[Test_Method]		  [varchar](35) NULL,
	[Test_Set_Abbrv_Afr]  [varchar](32) NOT NULL,
	[Test_Set_Abbrv_Eng]  [varchar](32) NOT NULL,
	[Test_Set_Loinc]      [varchar](64) NULL,
	[Test_Set_Afr]        [varchar](64) NULL,
	[Test_Set_Eng]        [varchar](64) NULL,
	[Test_Item_ID]        [varchar](64) NOT NULL,
	[Test_Item_Code]      [varchar](64) NOT NULL,
	[Test_Item_Abbrv_Afr] [varchar](32) NOT NULL,
	[Test_Item_Abbrv_Eng] [varchar](32) NOT NULL,
	[Test_Item_Loinc]     [varchar](64) NULL,
	[Test_Item_Afr]       [varchar](64) NULL,
	[Test_Item_Eng]       [varchar](64) NULL,
	[Add_ID]              [varchar](64) NOT NULL,
	[Add_Code]            [varchar](64) NOT NULL,
	[Add_Group]           [varchar](64) NOT NULL,
	[Add_SubGroup]        [varchar](32) NOT NULL,
	[Res_Loinc]           [varchar](64) NOT NULL,
	[Res_ItmID]           [varchar](32) NOT NULL,
	[Res_Item_Code]       [varchar](32) NOT NULL,
	[Res_Item_Abbrv]      [varchar](32) NOT NULL,
	[Res_Item]            [varchar](64) NOT NULL,
	[Res_Code]            [varchar](32) NOT NULL,
	[Result]              [varchar](64) NULL,
	[Units]               [varchar](32) NULL,
	[NormalRange]         [varchar](32) NULL,
	[AbnFlag]             [varchar](16) NULL,
	[tiSpecialResult]	  [tinyint]
	)   
AS

BEGIN
--
---
--
DECLARE	@RptLanguage CHAR(1)

SELECT  @RptLanguage=chLanguage
FROM [RS].[dbo].[tblSpecimen] Specimen (NOLOCK)
INNER JOIN [RS].[dbo].[tblRequisition] Requisition (NOLOCK) ON(Specimen.biRequisitionId=Requisition.biId)
INNER JOIN [RS].[dbo].[tblDoctorRequisition] DoctorRequisition (NOLOCK) ON(DoctorRequisition.birequisitionId=Requisition.biId)
INNER JOIN [RS].[dbo].[tblDoctor] Doctor (NOLOCK) ON (Doctor.iId=DoctorRequisition.iDoctorId AND [chReportType]='R')
WHERE Specimen.biId=@SpcID

/* PvN: retrieve parent result record to be able to access Method */
DECLARE @procedures TABLE (vchPrintNumberOrder varchar(40), vchMethod varchar(100))
INSERT INTO @procedures
SELECT
	r.vchPrintNumberOrder,
	r.vchMethod
	--,*
FROM
	RS.dbo.tblResult (NOLOCK) r
	INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
	r.biSpecimenId = s.biId
	LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
	r.vchPrintNumberResult = t.vchPrintNumber
AND r.chInloadsystem = t.chInloadsystem
AND	s.chDisciplineType = t.chDisciplineType
LEFT JOIN (
			SELECT
				r.*
			FROM
				RS.dbo.tblResult (NOLOCK) r
				INNER JOIN RS.dbo.tblSpecimen (NOLOCK) s ON
				r.biSpecimenId = s.biId
				LEFT JOIN RS.dbo.tblTest (NOLOCK) t ON
				r.vchPrintNumberResult = t.vchPrintNumber
			AND r.chInloadsystem = t.chInloadsystem
			AND	s.chDisciplineType = t.chDisciplineType
			WHERE
				r.biSpecimenId = @SpcID
			AND	vchMethod IS NULL
				) results ON
	r.vchPrintNumberResult = results.vchPrintNumberResult
WHERE
	r.biSpecimenId = @SpcID
AND	r.vchMethod IS NOT NULL
/* PvN: retrieve parent result record to be able to access Method */

--
--- Get Results
--
INSERT INTO @Results
SELECT DISTINCT

CASE WHEN R.[vchPrompt]='0' THEN '1' ELSE '2' END AS Res_Type

,COALESCE(RIGHT('00'+P.[Prompt_Seq1],2),'0') AS [Sort_Seq1]
,COALESCE(RIGHT('00'+P.[Prompt_Seq2],2),'0') AS [Sort_Seq2]
,CASE WHEN (SELECT MAX(RR.[tiSpecialResult]) FROM [RS].[dbo].[tblResult] RR (NOLOCK) 
                       WHERE RR.[biSpecimenId]=R.[biSpecimenId]
	                     AND RR.[vchPrintNumberResult]=R.[vchPrintNumberResult])=1  THEN '1' ELSE '999' END AS Res_Seq

,R.[vchPrintNumberOrder]               AS Test_Set_ID
,O.[vchTestMnemonic]                 AS Test_Set_Code
,pro.[vchMethod]						 AS Test_Method
,O.[vchAbbreviatedNameAfr]           AS [Test_Set_Abbrv_Afr]
,O.[vchAbbreviatedNameEng]           AS [Test_Set_Abbrv_Eng]
,COALESCE(O.[vchLoinc],'')           AS Test_Set_Loinc
,REPLACE(O.[vchOrderNameAfr],'*','') AS Test_Set_Afr
,REPLACE(O.[vchOrderNameEng],'*','') AS Test_Set_Eng

,R.[vchPrintNumberResult]              AS Test_Item_ID
,T.[vchTestMnemonic]                 AS Test_Set_Code
,T.[vchAbbreviatedNameAfr]           AS [Test_Item_Abbrv_Afr]
,T.[vchAbbreviatedNameEng]           AS [Test_Item_Abbrv_Eng]
,COALESCE(T.[vchLoinc],'')           AS Test_Item_Loinc
,REPLACE(T.[vchOrderNameAfr],'*','') AS Test_Item_Afr
,REPLACE(T.[vchOrderNameEng],'*','') AS Test_Item_Eng

,'' AS [Add_ID]
,'' AS [Add_Code]
,'' AS [Add_SubGroup]
,'' AS [Add_Group]

,'' AS Res_Loinc
,'' AS Res_ItmID
,'' AS Res_Item_Code
,'' AS Res_Item_Abbrv
,CASE WHEN [vchPrompt]='0' THEN '' ELSE (CASE WHEN @RptLanguage='A' THEN COALESCE(P.[Prompt_Afr],[vchPrompt]) ELSE COALESCE(P.[Prompt_Eng],[vchPrompt]) END) END AS Res_Item
,COALESCE(P.[Prompt_ID],T.[vchTestMnemonic]) AS Res_Code

,CASE 
	WHEN R.[tiSpecialResult] =0  THEN REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(R.vchResult,''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>') 
	WHEN R.[tiSpecialResult] =1  THEN R.vchResult
	ELSE '' END AS Result

,COALESCE(R.vchUnit,'')                               AS Units
,COALESCE(R.vchNormalRange,'')                        AS NormalRange
,COALESCE(R.vchAbnormalFlag,'')                       AS AbnFlag
,R.[tiSpecialResult]


  FROM  [RS].[dbo].[tblResult] R (NOLOCK)


  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Ord_Info] O (NOLOCK)
  ON  O.[chInloadSystem]  =R.[chInloadSystem]
  AND O.[chDisciplineType]='MIC'
  AND O.[vchPrintNumber]  =[vchPrintNumberOrder] 
  
  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info] T (NOLOCK)
  ON  T.[chInloadSystem]  =R.[chInloadSystem] 
  AND T.[chDisciplineType]='MIC' 
  AND T.[vchPrintNumber]  =[vchPrintNumberResult] 

  LEFT OUTER JOIN [RSReporting].[dbo].[tblRSR_MIC_Prompt_Seq] P (NOLOCK)
  ON  P.[LIS]=R.[chInloadSystem] COLLATE SQL_Latin1_General_CP1_CS_AS
  AND P.[Test_Item_ID]=[vchPrintNumberResult]
  AND (P.[Prompt_Eng]=[vchPrompt] OR [Prompt_Afr]=[vchPrompt])
  --AND (LEFT(P.[Prompt_Eng],10)=LEFT([vchPrompt],10) OR LEFT(P.[Prompt_Afr],10)=LEFT([vchPrompt],10))

  LEFT JOIN @procedures pro ON
  R.[vchPrintNumberOrder] COLLATE Latin1_General_CI_AS = pro.[vchPrintNumberOrder]

  WHERE R.[biSpecimenId]=@SpcID
    AND T.[RptElecYN]='Y'
    AND COALESCE(R.vchResult,'') NOT IN ('','ND','NP')
 
  --
  --- Get Organisms
  --
INSERT INTO @Results
  SELECT DISTINCT

'3' AS Res_Type

,'0' AS [Sort_Seq1]
,[iOrganismNumber] AS [Sort_Seq2]
,'0' AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,O.[vchTestMnemonic]                 AS Test_Set_Code
,R.[vchMethod]		                 AS Test_Method
,O.[vchAbbreviatedNameAfr]           AS [Test_Set_Abbrv_Afr]
,O.[vchAbbreviatedNameEng]           AS [Test_Set_Abbrv_Eng]
,COALESCE(O.[vchLoinc],'')           AS Test_Set_Loinc
,REPLACE(O.[vchOrderNameAfr],'*','') AS Test_Set_Afr
,REPLACE(O.[vchOrderNameEng],'*','') AS Test_Set_Eng

,[vchPrintNumberResult]              AS Test_Item_ID
,T.[vchTestMnemonic]                 AS Test_Set_Code
,T.[vchAbbreviatedNameAfr]+'ORG'           AS [Test_Item_Abbrv_Afr]
,T.[vchAbbreviatedNameEng]+'ORG'           AS [Test_Item_Abbrv_Eng]
,COALESCE(T.[vchLoinc],'')           AS Test_Item_Loinc
,REPLACE(T.[vchOrderNameAfr],'*','') AS Test_Item_Afr
--+' ORGANISME' 
,REPLACE(T.[vchOrderNameEng],'*','')  AS Test_Item_Eng
--+' ORGANISM' 

,'' AS [Add_ID]
,'' AS [Add_Code]
,'' AS [Add_SubGroup]
,'' AS [Add_Group]

,COALESCE([vchOrganismLoinc],'') AS Res_Loinc

,convert(varchar(2),[iOrganismNumber])  AS Res_ItmID
,Org.[vchOrgTestMnemonic] AS Res_Item_Code
,[vchOrganismNameAbbreviation] AS Res_Item_Abbrv

,(CASE WHEN @RptLanguage='A' THEN 'Organisme' ELSE 'Organism ' END)+convert(varchar(2),[iOrganismNumber]) AS Res_Item
,[vchOrgPrintNumber] AS Res_Code
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Org.vchOrganismName,'*',''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>') AS Result
,''                    AS Units
,''                    AS NormalRange
,''                    AS AbnFlag
,R.[tiSpecialResult]



  FROM  [RS].[dbo].[tblResult] R (NOLOCK)


  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Ord_Info] O (NOLOCK)
  ON  O.[chInloadSystem]  =R.[chInloadSystem]
  AND O.[chDisciplineType]='MIC'
  AND O.[vchPrintNumber]  =[vchPrintNumberOrder] 
  
  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info] T (NOLOCK)
  ON  T.[chInloadSystem]  =R.[chInloadSystem] 
  AND T.[chDisciplineType]='MIC' 
  AND T.[vchPrintNumber]  =[vchPrintNumberResult]  

INNER JOIN [RS].[dbo].[tblMicro] Mic (nolock)
on Mic.biResultId    = R.biId
and Mic.biSpecimenId = R.[biSpecimenId]

INNER JOIN [RS].[dbo].[tblOrganism] Org (nolock)
on Org.iId=Mic.iOrganismId


  WHERE R.[biSpecimenId]=@SpcID
    AND [iOrganismNumber] IS NOT NULL
--
--- Get Org Results
--

INSERT INTO @Results
  SELECT DISTINCT

'3' AS Res_Type

,'0' AS [Sort_Seq1]
,[iOrganismNumber] AS [Sort_Seq2]
,COALESCE([Seq],0) AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,O.[vchTestMnemonic]                 AS Test_Set_Code
,R.[vchMethod]						 AS Test_Method
,O.[vchAbbreviatedNameAfr]           AS [Test_Set_Abbrv_Afr]
,O.[vchAbbreviatedNameEng]           AS [Test_Set_Abbrv_Eng]
,COALESCE(O.[vchLoinc],'')           AS Test_Set_Loinc
,REPLACE(O.[vchOrderNameAfr],'*','') AS Test_Set_Afr
,REPLACE(O.[vchOrderNameEng],'*','') AS Test_Set_Eng

,[vchPrintNumberResult]              AS Test_Item_ID
,T.[vchTestMnemonic]                 AS Test_Set_Code
,T.[vchAbbreviatedNameAfr]+'ORG'           AS [Test_Item_Abbrv_Afr]
,T.[vchAbbreviatedNameEng]+'ORG'           AS [Test_Item_Abbrv_Eng]
,COALESCE(T.[vchLoinc],'')           AS Test_Item_Loinc
,REPLACE(T.[vchOrderNameAfr],'*','') AS Test_Item_Afr
--+' ORGANISME' 
,REPLACE(T.[vchOrderNameEng],'*','')  AS Test_Item_Eng
--+' ORGANISM' 

,'' AS [Add_ID]
,'' AS [Add_Code]
,'' AS [Add_SubGroup]
,'' AS [Add_Group]

,COALESCE([vchPromptLoinc],'') AS Res_Loinc

,convert(varchar(2),[iOrganismNumber]) AS Res_ItmID
,'' AS Res_Item_Code
,COALESCE(Org.[vchPromptMnemonic],'') AS Res_Item_Abbrv

,'     '+Org.vchPrompt AS Res_Item
,[vchPromptResponseMnemonic] AS Res_Code

,COALESCE(Org.vchPromptResponse,'') AS Result
,''                    AS Units
,''                    AS NormalRange
,''                    AS AbnFlag
,R.[tiSpecialResult]




  FROM  [RS].[dbo].[tblResult] R (NOLOCK)


  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Ord_Info] O (NOLOCK)
  ON  O.[chInloadSystem]  =R.[chInloadSystem]
  AND O.[chDisciplineType]='MIC'
  AND O.[vchPrintNumber]  =[vchPrintNumberOrder] 
  
  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info] T (NOLOCK)
  ON  T.[chInloadSystem]  =R.[chInloadSystem] 
  AND T.[chDisciplineType]='MIC' 
  AND T.[vchPrintNumber]  =[vchPrintNumberResult]  

INNER JOIN [RS].[dbo].[tblMicro] Mic (nolock)
on Mic.biResultId    = R.biId
and Mic.biSpecimenId = R.[biSpecimenId]

INNER JOIN [RS].[dbo].[tblOrganism] Org (nolock)
on Org.iId=Mic.iOrganismId

LEFT OUTER JOIN [RSReporting].[dbo].[tblRSR_MIC_Org_Prompt_Seq] Z (NOLOCK)
ON  Z.[LIS]=R.[chInloadSystem] COLLATE SQL_Latin1_General_CP1_CS_AS
AND Z.[Organism]=Org.[vchOrgTestMnemonic]
AND Z.[Prompt]=Org.[vchPromptMnemonic]

  WHERE R.[biSpecimenId]=@SpcID
    AND [vchPromptResponseMnemonic] IS NOT NULL
  --
  --- Get Sensitivities
  --
INSERT INTO @Results
  SELECT DISTINCT

'6' AS Res_Type

,'0' AS [Sort_Seq1]
,'0' AS [Sort_Seq2]
,'999' AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,O.[vchTestMnemonic]                 AS Test_Set_Code
,R.[vchMethod]						 AS Test_Method
,O.[vchAbbreviatedNameAfr]           AS [Test_Set_Abbrv_Afr]
,O.[vchAbbreviatedNameEng]           AS [Test_Set_Abbrv_Eng]
,COALESCE(O.[vchLoinc],'')           AS Test_Set_Loinc
,REPLACE(O.[vchOrderNameAfr],'*','') AS Test_Set_Afr
,REPLACE(O.[vchOrderNameEng],'*','') AS Test_Set_Eng

,[vchPrintNumberResult]              AS Test_Item_ID
,T.[vchTestMnemonic]                 AS Test_Set_Code
,T.[vchAbbreviatedNameAfr]+'KOM'     AS [Test_Item_Abbrv_Afr]
,T.[vchAbbreviatedNameEng]+'COM'     AS [Test_Item_Abbrv_Eng]
,COALESCE(T.[vchLoinc],'')           AS Test_Item_Loinc
,REPLACE(T.[vchOrderNameAfr],'*','')+' KOMMENTAAR' AS Test_Item_Afr
,REPLACE(T.[vchOrderNameEng],'*','')+' COMMENT'    AS Test_Item_Eng

,'' AS [Add_ID]
,'' AS [Add_Code]
,'' AS [Add_SubGroup]
,'' AS [Add_Group]

,'' AS Res_Loinc

,'' AS Res_ItmID
,'' AS Res_Item_Code
,'' AS Res_Item_Abbrv
,'' AS Res_Item
,'' AS Res_Code
,''                    AS Result
,''                    AS Units
,''                    AS NormalRange
,''                    AS AbnFlag
,R.[tiSpecialResult]




  FROM [RS].[dbo].[tblResult] R (NOLOCK)


  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Ord_Info] O (NOLOCK)
  ON  O.[chInloadSystem]  =R.[chInloadSystem]
  AND O.[chDisciplineType]='MIC'
  AND O.[vchPrintNumber]  =[vchPrintNumberOrder] 
  
  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info] T (NOLOCK)
  ON  T.[chInloadSystem]  =R.[chInloadSystem] 
  AND T.[chDisciplineType]='MIC' 
  AND T.[vchPrintNumber]  =[vchPrintNumberResult] 

INNER JOIN [RS].[dbo].[tblMicro] Mic (nolock)
on Mic.biResultId    = R.biId
and Mic.biSpecimenId = R.[biSpecimenId]

INNER JOIN [RS].[dbo].[tblOrganism] Org (nolock)
on Org.iId=Mic.iOrganismId

INNER JOIN [RS].[dbo].[tblOrganismSensitivity] N (NOLOCK)
ON N.[iId]=Mic.[iOrganismSensitivityId]

WHERE R.[biSpecimenId]=@SpcID
AND COALESCE([vchSensPrintNumber],'')<>''

--
--- Get Antibiotics - MIC
--
INSERT INTO  @Results
SELECT DISTINCT

'6' AS Res_Type

,CASE WHEN COALESCE([AntiBiotic_Grp_ID],'0')='0' THEN '999' ELSE [AntiBiotic_Grp_ID] END  AS [Sort_Seq1]
,CASE WHEN COALESCE([AntiBiotic_Sub_ID],'0')='0' THEN [vchPrintNumberResult] ELSE [AntiBiotic_Sub_ID] END  AS [Sort_Seq2]
,CONVERT(VARCHAR(3),Mic.iOrganismNumber)    AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,O.[vchTestMnemonic]                 AS Test_Set_Code
,R.[vchMethod]						 AS Test_Method
,O.[vchAbbreviatedNameAfr]           AS [Test_Set_Abbrv_Afr]
,O.[vchAbbreviatedNameEng]           AS [Test_Set_Abbrv_Eng]
,COALESCE(O.[vchLoinc],'')           AS Test_Set_Loinc
,'Antibiogram : Organisme '+CONVERT(VARCHAR(2),[iOrganismNumber])+' - '+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Org.vchOrganismName,'*',''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>') AS Test_Set_Afr
,'Antibiogram : Organism '+CONVERT(VARCHAR(2),[iOrganismNumber])+' - '+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Org.vchOrganismName,'*',''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>')  AS Test_Set_Eng

,[vchPrintNumberResult]              AS Test_Item_ID
,T.[vchTestMnemonic]                 AS Test_Set_Code
,T.[vchAbbreviatedNameAfr]           AS [Test_Item_Abbrv_Afr]
,T.[vchAbbreviatedNameEng]           AS [Test_Item_Abbrv_Eng]
,COALESCE(T.[vchLoinc],'')           AS Test_Item_Loinc
,'Antibiogram : Organisme '+CONVERT(VARCHAR(2),[iOrganismNumber])+' - '+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Org.vchOrganismName,'*',''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>') AS Test_Set_Afr
,'Antibiogram : Organism '+CONVERT(VARCHAR(2),[iOrganismNumber])+' - '+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Org.vchOrganismName,'*',''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>')  AS Test_Set_Eng


,[AntiBiotic_Grp_ID]   AS [Add_ID]
,[AntiBiotic_Grp_Code] AS [Add_Code]

,CASE WHEN @RptLanguage='A' THEN [AntiBiotic_Grp_Afr] ELSE [AntiBiotic_Grp_Eng] END AS [Add_Group]
,CASE WHEN @RptLanguage='A' THEN [AntiBiotic_Sub_Afr] ELSE [AntiBiotic_Sub_Eng] END AS [Add_SubGroup]

,COALESCE([vchLoincMIC],[vchLoincKB],'')    AS Res_Loinc
,RIGHT('0'+LEFT ([vchAntibioticPrintNumber],(CHARINDEX('.',[vchAntibioticPrintNumber])-1)),4)+'.'+
 RIGHT('0'+SUBSTRING ([vchAntibioticPrintNumber],(CHARINDEX('.',[vchAntibioticPrintNumber])+1),5),5)   AS Res_ItmID
,COALESCE([vchAntibioticMnemonic],'')       AS Res_Item_Code
--,[vchAntibioticNameAbbr]                    AS Res_Item_Abbrv
,[vchOrganismNameAbbreviation]                AS Res_Item_Abbrv

--PvN: 2019-04-26 > replaced Res_Item value based on email from Rob (subject: Antibiotic Name [received on Fri 2019/04/26 10:10 AM])
--,OrgA.vchAntibioticName  AS Res_Item
, CASE WHEN @RptLanguage='A' THEN AI.[AntiBiotic_Name_Afr] ELSE AI.[AntiBiotic_Name_Eng] END AS Res_Item

,'' AS Res_Code
,COALESCE(Mic.vchMIC,'') AS Result
,''                              AS Units
,'' AS NormalRange
,COALESCE(OrgA.chSensitivity,'') AS AbnFlag
,R.[tiSpecialResult]



  FROM [RS].[dbo].[tblResult] R (NOLOCK)


  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Ord_Info] O (NOLOCK)
  ON  O.[chInloadSystem]  =R.[chInloadSystem]
  AND O.[chDisciplineType]='MIC'
  AND O.[vchPrintNumber]  =[vchPrintNumberOrder] 
  
  INNER JOIN [RSReporting].[dbo].[tblRSR_Test_Res_Info] T (NOLOCK)
  ON  T.[chInloadSystem]  =R.[chInloadSystem] 
  AND T.[chDisciplineType]='MIC' 
  AND T.[vchPrintNumber]  =[vchPrintNumberResult] 

INNER JOIN [RS].[dbo].[tblMicro] Mic (nolock)
on Mic.biResultId = R.biId
and Mic.biSpecimenId = R.[biSpecimenId] 

INNER JOIN [RS].[dbo].[tblOrganism] Org (nolock)
on Org.iId=Mic.iOrganismId
and Org.[chInloadSystem]=R.[chInloadSystem]

INNER JOIN [RS].[dbo].[tblOrganismSensitivity] OrgS (nolock)
on OrgS.iId=Mic.iOrganismSensitivityId
and OrgS.[chInloadSystem]=R.[chInloadSystem]

INNER JOIN [RS].[dbo].[tblOrganismAntibiotic] OrgA (nolock)
on OrgA.iId=Mic.iOrganismAntibioticId
and OrgA.[chInloadSystem]=R.[chInloadSystem]

LEFT OUTER JOIN [RS].[dbo].[tblMIC_Growth_Text] Mgt  (nolock)
on Mgt.Afrikaans_Text=Org.vchPromptResponse


INNER JOIN [RSReporting].[dbo].[tblRSR_MIC_Antibiotic_Info] AI (NOLOCK)
ON  AI.[LIS]=R.[chInloadSystem] COLLATE SQL_Latin1_General_CP1_CS_AS
AND AI.[AntiBiotic_ID]=[vchAntibioticPrintNumber]

WHERE R.[biSpecimenId]=@SpcID
AND OrgA.chreportable='Y'


RETURN
END
