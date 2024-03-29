USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_incomingPayment]    Script Date: 31/07/2019 9:52:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_ITN_incomingPayment] (@DocKey INT)
AS
BEGIN
	SELECT 'IncomingPayment'
		,T2."DocDate" AS "DocDate"
		,T2."DocNum"
		,T3."FormatCode"
		,ISNULL(T2."PrjCode",'') AS "PrjCode"
		,ISNULL(T3."AcctName",'') AS "AccountName"
		,ISNULL(T1."LineMemo",'') AS "LineMemo"
		,T1."Debit"
		,T1."Credit"
		,[dbo].ITN_NEPALI_FMT_DATE(T2."U_ITN_NPDate") AS "NP Date"
		--,CONCAT(SUBSTRING(T2."U_ITN_NPDate", 0, 4) , '/' , SUBSTRING(T2."U_ITN_NPDate", 5, 2) , '/' , SUBSTRING(T2."U_ITN_NPDate", 7, 2)) AS "NP Date"
		,ISNULL(T4."BeginStr", '') + CAST(T2."DocNum" AS nvarchar) + CAST(T4."EndStr" AS nvarchar) AS "VoucherNo"
		,ISNULL(T5."PrcName",'') AS "Employee"
		,ISNULL(T6."PrcName",'') AS "Department"
		,ISNULL(T7."PrcName",'') AS "Division"
		,ISNULL(T8."PrcName",'') AS "Asset"
		,ISNULL(T9."PrcName",'') AS "Others"
		,CASE 
			WHEN ISNULL(T10."Descrip", '') = ''
				THEN ISNULL(T2."Comments",'')
			ELSE ISNULL(T10."Descrip",'')
			END AS "Remarks"
		,T2."JrnlMemo" AS "Narration"
		,T0."TransId"
		,T2."TransId" AS "DCno"
		,T2."DocEntry"
		,ISNULL(T11."CardName",'') AS "Customer"
	,CASE 
	    WHEN  T2."CashSum" <> 0
	         THEN 'Cash Receipt'
	    WHEN T2."CreditSum"<>  0
	         THEN 'Credit Receipt'
	    WHEN T2."CheckSum" <>  0
	         THEN 'Cheque Receipt'
	    WHEN T2."TrsfrSum"<> 0
	        THEN 'Bank  Receipt'
    END AS "PaymentType"   
	,B."USER_CODE" AS "PrepaidBy"
	FROM OJDT T0
	INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId"
	INNER JOIN ORCT T2 ON T0."TransId" = T2."TransId"
	LEFT JOIN OACT T3 ON T1."ShortName" = T3."AcctCode"
	LEFT JOIN NNM1 T4 ON T4."Series" = T2."Series"
	LEFT JOIN OPRC T5 ON T5."PrcCode" = T1."ProfitCode"
	LEFT JOIN OPRC T6 ON T6."PrcCode" = T1."OcrCode2"
	LEFT JOIN OPRC T7 ON T7."PrcCode" = T1."OcrCode3"
	LEFT JOIN OPRC T8 ON T8."PrcCode" = T1."OcrCode4"
	LEFT JOIN OPRC T9 ON T9."PrcCode" = T1."OcrCode5"
	LEFT JOIN RCT4 T10 ON T10."DocNum" = T2."DocEntry"
		AND T10."AcctCode" = T1."Account"
		AND T10."LineId" = T1."Line_ID" - 1
	LEFT JOIN OCRD T11 ON T11."CardCode" = T1."ShortName"
	LEFT JOIN NNM1 T12 ON T12."Series" = T2."Series"
	INNER JOIN OUSR B ON T0."UserSign" = B."INTERNAL_K"
	WHERE T2."DocEntry" = @DocKey;
	END
