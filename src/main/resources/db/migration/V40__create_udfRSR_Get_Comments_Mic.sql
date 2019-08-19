USE [RSReporting]
GO
IF OBJECT_ID('dbo.udfRSR_Get_Comments_Mic') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udfRSR_Get_Comments_Mic
	IF OBJECT_ID('dbo.udfRSR_Get_Comments_Mic') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO
/****** Object:  UserDefinedFunction [dbo].[udfRSR_Get_Comments_Mic]    Script Date: 5/22/2019 10:37:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udfRSR_Get_Comments_Mic] (@SpcID BIGINT)
RETURNS

 @Comments TABLE (
	[Res_Type] [varchar](1) NOT NULL,
	[Sort_Seq1] [varchar](64) NOT NULL,
	[Sort_Seq2] [varchar](64) NOT NULL,
	[Res_Seq] [varchar](3) NULL,
	[Test_Set_ID] [varchar](20) NOT NULL,
	[Test_Item_ID] [varchar](40) NOT NULL,
	[Res_ItmID] [varchar](32) NOT NULL,
	[Res_Item_Code] [varchar](20) NOT NULL,
	[Comment] [varchar](max) NULL
	)
AS
BEGIN
--
--- Get Result Comments Part 1
--
INSERT INTO @Comments
SELECT DISTINCT

CASE WHEN R.[vchPrompt]='0' THEN '1' ELSE '2' END AS Res_Type

,COALESCE(RIGHT('00'+P.[Prompt_Seq1],2),'0') AS [Sort_Seq1]
,COALESCE(RIGHT('00'+P.[Prompt_Seq2],2),'0') AS [Sort_Seq2]
,CASE WHEN (SELECT MAX(RR.[tiSpecialResult]) FROM [RS].[dbo].[tblResult] RR (NOLOCK)
                       WHERE RR.[biSpecimenId]=R.[biSpecimenId]
	                     AND RR.[vchPrintNumberResult]=R.[vchPrintNumberResult])=1  THEN '1' ELSE '999' END AS Res_Seq


,[vchPrintNumberOrder]               AS Test_Set_ID
,[vchPrintNumberResult]              AS Test_Item_ID
,'' AS Res_ItmID
,'' AS Res_Code

,COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments] (R.[biId]),'')



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
  AND (LEFT(P.[Prompt_Eng],10)=LEFT([vchPrompt],10) OR LEFT(P.[Prompt_Afr],10)=LEFT([vchPrompt],10))

WHERE R.[biSpecimenId]=@SpcID
  AND T.[RptElecYN]='Y'
  AND COALESCE(R.vchResult,'') NOT IN ('','ND','NP')
  AND COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments] (R.[biId]),'')<>''

--
--- Get Result Comments Part 2
--
INSERT INTO @Comments
SELECT DISTINCT

CASE WHEN R.[vchPrompt]='0' THEN '1' ELSE '2' END AS Res_Type

,COALESCE(RIGHT('00'+P.[Prompt_Seq1],2),'0') AS [Sort_Seq1]
,COALESCE(RIGHT('00'+P.[Prompt_Seq2],2),'0') AS [Sort_Seq2]
,CASE WHEN (SELECT MAX(RR.[tiSpecialResult]) FROM [RS].[dbo].[tblResult] RR (NOLOCK)
                       WHERE RR.[biSpecimenId]=R.[biSpecimenId]
	                     AND RR.[vchPrintNumberResult]=R.[vchPrintNumberResult])=1  THEN '1' ELSE '999' END AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,[vchPrintNumberResult]              AS Test_Item_ID
,'' AS Res_ItmID
,'' AS Res_Code

,(SELECT   '          '+ REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(RR.vchResult,''),'|',''),'&amp;','&'),'&lt;','<'),'&gt;','>')  + CHAR(10)
  FROM [RS].[dbo].[tblResult] RR (NOLOCK)
  WHERE RR.[biSpecimenId]=R.[biSpecimenId]
	AND RR.[vchPrintNumberResult]=R.[vchPrintNumberResult]
    AND RR.[vchPrompt]='0'
    AND COALESCE(RR.vchResult,'') NOT IN ('ND','NP','')
    AND LEFT(LTRIM(RR.vchResult),1)!='@'
  ORDER BY  RR.[tiSpecialResult]
  FOR XML PATH(''),root('Comment'),type).value('/Comment[1]','VARCHAR(MAX)')


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
  AND (LEFT(P.[Prompt_Eng],10)=LEFT([vchPrompt],10) OR LEFT(P.[Prompt_Afr],10)=LEFT([vchPrompt],10))


  WHERE R.[biSpecimenId]=@SpcID
  AND R.[vchPrompt]='0'
  AND T.[RptElecYN]='Y'
  AND COALESCE(R.vchResult,'') NOT IN ('ND','NP')
  AND LEFT(LTRIM(R.vchResult),1)!='@'
  AND (SELECT  RR.vchResult  FROM [RS].[dbo].[tblResult] RR (NOLOCK)
                            WHERE RR.[biSpecimenId]=R.[biSpecimenId]
	                          AND RR.[vchPrintNumberResult]=R.[vchPrintNumberResult]
                              AND RR.[vchPrompt]='0'
                              AND COALESCE(RR.vchResult,'') NOT IN ('ND','NP','')
                              AND LEFT(LTRIM(RR.vchResult),1)!='@') IS NOT NULL
--
--- Get Organism Comments part 1
--
  INSERT INTO  @Comments
  SELECT DISTINCT

'3' AS Res_Type

,'0' AS [Sort_Seq1]
,[iOrganismNumber] AS [Sort_Seq2]
,'0'
--,COALESCE([Seq],0) AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,[vchPrintNumberResult]              AS Test_Item_ID
,'' AS Res_ItmID
,'' AS Res_Code

,COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments_MIC] (R.[biId],1),'')

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

  AND COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments_MIC] (R.[biId],1),'')<>''

--
--- Get Organism Comments part 2
--
  INSERT INTO  @Comments
  SELECT DISTINCT

'6' AS Res_Type

,'0' AS [Sort_Seq1]
,'0'
--,[iOrganismNumber] AS [Sort_Seq2]
,'999' AS Res_Seq

,[vchPrintNumberOrder]   AS Test_Set_ID
,[vchPrintNumberResult]  AS Test_Item_ID
,'' AS Res_ItmID
,'' AS Res_Code

,COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments] (R.[biId]),'')

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
  AND R.[vchPrompt]='0'
  AND COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments] (R.[biId]),'')<>''

--
--- Get Sens Comments
--
  INSERT INTO  @Comments
  SELECT DISTINCT

'6' AS Res_Type

,'0' AS [Sort_Seq1]
,'0' AS [Sort_Seq2]
,'999' AS Res_Seq

,[vchPrintNumberOrder]               AS Test_Set_ID
,[vchPrintNumberResult]              AS Test_Item_ID
,'' AS Res_ItmID
,'' AS Res_Code

,COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments_MIC] (R.[biId],2),'')

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
  AND COALESCE([RSReporting].[dbo].[udfRSR_Get_Result_Comments_MIC] (R.[biId],2),'')<>''
RETURN
END
