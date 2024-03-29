USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_exciseSalesRegister]    Script Date: 31/07/2019 9:51:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_ITN_exciseSalesRegister]
AS
BEGIN
---for hulas auoto craft
SELECT T1."DocDate" AS "Sales Date"
	,T1."DocEntry"
	,T1."DocNum"
	,ISNULL(T4."BeginStr", '') + CAST(T1."DocNum" AS nvarchar) + ISNULL(CAST(T4."EndStr" AS nvarchar), '') AS "Sales No"
	,[dbo].ITN_NEPALI_FMT_DATE(T1."U_ITN_NPDate") AS "Sales Miti"
	---,SUBSTRING(T1."U_ITN_NPDate", 0, 4) || '/' || SUBSTRING(T1."U_ITN_NPDate", 5, 2) || '/' || SUBSTRING(T1."U_ITN_NPDate", 7, 2) AS "Sales Miti"
	,CASE WHEN T2.TaxCode='EX30VA13' THEN SUM(ISNULL(T2.Price, 0)-ISNULL(T1."DiscSum",0)) END AS "Excisable Amount"
	,CASE WHEN T2.TaxCode='EX30VA13' THEN  SUM(ISNULL(T2.Price, 0)-ISNULL(T1."DiscSum",0))*0.3 END AS "Excise Amount"
	--,CASE when T2.TaxCode='EX30VA13' THEN
	--ISNULL(T2."LineVatS", 0)*0.3 
	--ELSE '-'
	--END AS "Excise Amount" -----For Hulas Auto Craft
	--,SUM(ISNULL(T2."Quantity", 0) * ISNULL(T2."PriceBefDi", 0)) AS "Excisable Amount"
	--,SUM(ISNULL(T2."Quantity", 0) * ISNULL(CAST(T2."U_ITN_EXPU" AS INT), 0)) AS "Excise Amount"
	,CASE 
		WHEN T1."CANCELED" = 'Y'
			THEN 'CANCEL'
		ELSE T1."CardName"
		END AS "CustomerName"

		,CASE
		    WHEN T2."PriceBefDi">=0
			and t1."DocType"='Import'---> (t1."DocType"='Import' IS UDF FIELD VALUE)
			THEN '0'
			ELSE '-'
			END AS "ZeroRatedSales"
		

	,T5."TaxId4" AS "Pan No"
	,CASE WHEN T2."TaxCode" LIKE '%EXEEMPT%' THEN SUM(ISNULL(T2."Quantity", 0) * ISNULL(T2."PriceBefDi", 0)) ELSE 0 END AS "EXEMPT Amount"
	,T6."Location" AS Location
FROM OINV T1
LEFT JOIN INV1 T2 ON T1."DocEntry" = T2."DocEntry"
LEFT JOIN OITM T3 ON T3."ItemCode" = T2."ItemCode"
	AND T2."ObjType" = '13'
LEFT JOIN NNM1 T4 ON T4."Series" = T1."Series"
LEFT JOIN CRD7 T5 ON T5."CardCode" = T1."CardCode"
	AND T5."Address" = ''
	AND T5."AddrType" = 'S'
LEFT JOIN OLCT T6 ON T6."Code" = T2."LocCode"	
WHERE T1.DocDate BETWEEN '05-28-2019'AND '05-28-2019'
GROUP BY T1."CANCELED"
	,T1."DocDate"
	,T1."DocEntry"
	,T1."DocNum"
	,T4."BeginStr"
	,T1."CardName"
	,T2."TaxCode"
	,T4."EndStr"
	,T1."U_ITN_NPDate"
	,T5."TaxId4"
	,T6."Location"
    ,T2."PriceBefDi"
    ,t1."DocType"
    ,T1."DiscSum"
	,T2."LineVatS"
ORDER BY T1."DocNum";
END



