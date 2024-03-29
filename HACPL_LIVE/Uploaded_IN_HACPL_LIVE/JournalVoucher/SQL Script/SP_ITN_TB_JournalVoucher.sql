USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_TB_JournalVoucher]    Script Date: 31/07/2019 9:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ITN_TB_JournalVoucher] (@DocKey INT)
	AS
	BEGIN

SELECT 
	T0."RefDate"
	,T0."Number"
	,T3."FormatCode"
	,T4."Remark" AS "Project"
	,T3."AcctName" AS "AccountName"
	,T1."LineMemo"
	,T1."Debit"
	,T1."Credit"
	,T1."TaxDate" As "DocDate"
	--,CONCAT(SUBSTRING(T0."U_ITN_NPDate", 0, 4) , '/' , SUBSTRING(T0."U_ITN_NPDate", 5, 2) , '/' , SUBSTRING(T0."U_ITN_NPDate", 7, 2)) AS "NPDate"
	,[dbo].ITN_NEPALI_FMT_DATE (T0.U_ITN_NPDate) as "NPdate"
	,CONCAT(ISNULL(T4."BeginStr", '') , CAST(T0."Number" AS nvarchar) , CAST(T4."EndStr" AS CHAR(20))) AS "DocNo"
	,T5."PrcName" AS "Employee"
	,T6."PrcName" AS "Department"
	,T7."PrcName" AS "Division"
	,T8."PrcName" AS "Asset"
	,T9."PrcName" AS "Others"
	,T1."LineMemo" AS "Rmk"
	,T0."TransId"
	,T0."Memo" AS "Narration"
	--T2."TransId" as "DCno",
	--T2."DocEntry",
	,T11."CardName"
	,B."U_NAME"
	,ISNULL(T0."StornoToTr", 0) "StornoToTr"
FROM OJDT T0
---SELECT * FROM OJDT WHERE "BaseRef"='180733'
INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId"
--INNER JOIN OVPM T2 ON T0."TransId" = T2."TransId" 
LEFT JOIN OACT T3 ON T1."ShortName" = T3."AcctCode"
LEFT JOIN NNM1 T4 ON T4."Series" = T0."Series"
LEFT JOIN OPRC T5 ON T5."PrcCode" = T1."ProfitCode"
LEFT JOIN OPRC T6 ON T6."PrcCode" = T1."OcrCode2"
LEFT JOIN OPRC T7 ON T7."PrcCode" = T1."OcrCode3"
LEFT JOIN OPRC T8 ON T8."PrcCode" = T1."OcrCode4"
LEFT JOIN OPRC T9 ON T9."PrcCode" = T1."OcrCode5"
--LEFT JOIN VPM4 T10 ON T10."DocNum"=T2."DocNum" AND T10."AcctCode"=T1."Account" AND T10."LineId"=T1."Line_ID"-1
LEFT JOIN OCRD T11 ON T11."CardCode" = T1."ShortName"
LEFT JOIN NNM1 T12 ON T12."Series" = T0."Series"
INNER JOIN OUSR B ON T0."UserSign" = B."INTERNAL_K"
WHERE T0."TransId"=@DocKey;
END