USE [RSReporting]
GO

IF OBJECT_ID('dbo.udfRSR_DeltaCheck') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.udfRSR_DeltaCheck
	IF OBJECT_ID('dbo.udfRSR_DeltaCheck') IS NOT NULL PRINT 'Failed to drop sp!!!' ELSE PRINT 'Dropped'
END
GO

/****** Object:  UserDefinedFunction [dbo].[udfRSR_DeltaCheck]    Script Date: 5/22/2019 10:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udfRSR_DeltaCheck] (@PCS_RID AS BIGINT)
RETURNS VARCHAR(64)  AS

BEGIN
DECLARE @Delta AS VARCHAR(64)

SET @Delta=(SELECT DISTINCT
				CASE WHEN [PERCENTDIFF]  IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])<=CONVERT(FLOAT,HistResult)-(CONVERT(FLOAT,A.[vchResult])*(CONVERT(FLOAT,[PERCENTDIFF])/100)) THEN '     *** Delta : '+HistResult+' - '+CONVERT(varchar(24),HistVerifyDT)
					 WHEN [PERCENTDIFF]  IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])>=CONVERT(FLOAT,HistResult)+(CONVERT(FLOAT,A.[vchResult])*(CONVERT(FLOAT,[PERCENTDIFF])/100)) THEN '     *** Delta : '+HistResult+' - '+CONVERT(varchar(24),HistVerifyDT)
					 WHEN [ABSOLUTEDIFF] IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])<=CONVERT(FLOAT,HistResult)-CONVERT(FLOAT,[ABSOLUTEDIFF]) THEN '     *** Delta : '+HistResult+' - '+CONVERT(varchar(24),HistVerifyDT)
					 WHEN [ABSOLUTEDIFF] IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])>=CONVERT(FLOAT,HistResult)+CONVERT(FLOAT,[ABSOLUTEDIFF]) THEN '     *** Delta : '+HistResult+' - '+CONVERT(varchar(24),HistVerifyDT)
				ELSE '' END AS deltaCheck
			 FROM [RS].[dbo].[tblResult] A (NOLOCK)
				 INNER JOIN  [RS].[dbo].[tblSpecimen] C (NOLOCK) ON (C.[biId]=A.[biSpecimenId])
				 INNER JOIN [RS].[dbo].[tblRequisition] D (NOLOCK)	ON (D.[biId]=C.[biRequisitionId])
				 INNER JOIN [RS].[dbo].[tblPatient] E (NOLOCK) ON (E.[biId]=D.[biPatientId])

				 INNER JOIN  [RSReporting].[dbo].[tblRSR_Lab_DeltaTests] B (NOLOCK) ON ([PRINTNUMBER]=[vchPrintNumberResult]
																					AND [RESULTGROUP]=A.[vchMethod]
																					AND [NUMSEX]=E.[chPatGender]
																					AND [NUMAGE]=(SELECT MAX([NUMAGE])
																									FROM [RSReporting].[dbo].[tblRSR_Lab_DeltaTests]
																									WHERE [PRINTNUMBER]=[vchPrintNumberResult]
																									  AND [RESULTGROUP]=A.[vchMethod]
																									  AND [NUMSEX]=E.[chPatGender]
																									  AND [NUMAGE]<=D.[vchAge]))

				  INNER JOIN  RSReporting.dbo.vwRSR_Patient_Result_History f  ON (HistID=E.[vchMRI]
																	  AND HistTest=[vchPrintNumberResult]
																	  AND HistMethod=A.[vchMethod]
																	  AND HistVerifyDT=(SELECT MAX(HistVerifyDT)
																						FROM RSReporting.dbo.vwRSR_Patient_Result_History
																						WHERE HistID =E.[vchMRI]
																								 AND HistTest  =[vchPrintNumberResult]
																								 AND HistMethod  =A.[vchMethod]
																								AND HistVerifyDT<A.[dtVerified])
																	)

				  WHERE A.biId=@PCS_RID
				    AND ISNUMERIC(HistResult)=1
					AND ISNUMERIC([vchResult])=1
					AND ([PERCENTDIFF] IS NOT NULL OR [ABSOLUTEDIFF] IS NOT NULL)
					AND (CASE WHEN [PERCENTDIFF]  IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])<=CONVERT(FLOAT,HistResult)-(CONVERT(FLOAT,A.[vchResult])*(CONVERT(FLOAT,[PERCENTDIFF])/100)) THEN 'Y'
					          WHEN [PERCENTDIFF]  IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])>=CONVERT(FLOAT,HistResult)+(CONVERT(FLOAT,A.[vchResult])*(CONVERT(FLOAT,[PERCENTDIFF])/100)) THEN 'Y'
					          WHEN [ABSOLUTEDIFF] IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])<=CONVERT(FLOAT,HistResult)-CONVERT(FLOAT,[ABSOLUTEDIFF]) THEN 'Y'
					          WHEN [ABSOLUTEDIFF] IS NOT NULL AND CONVERT(FLOAT,A.[vchResult])>=CONVERT(FLOAT,HistResult)+CONVERT(FLOAT,[ABSOLUTEDIFF]) THEN 'Y'
				ELSE 'N' END)='Y')

RETURN @Delta

END