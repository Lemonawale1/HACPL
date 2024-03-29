USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_materializedView]    Script Date: 31/07/2019 9:52:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ITN_materializedView]
AS
BEGIN
	SELECT DISTINCT T0."DocEntry"
		,T0."PIndicator"
		,T0.U_ITN_Print_Count
		,T0."Printed"
		,isnull(CAST(T0."U_ITN_Is_Synced"AS nvarchar),'false') as "IsSynced"
		,isnull(CAST(T0."U_ITN_Is_RealTime" AS nvarchar),'false') as "IsRealTime"
		,T0."ObjType"
		,T0."DocStatus"
		,T0."CANCELED"
		,t6."SeriesName"
		,'AR INVOICE' AS "DOCTYPE"
		,T1."BaseRef"
		,T0."DocNum"
		,T0."DocDate"
		,T0."CardCode"
		,T0."CardName"
		,T0."NumAtCard" AS "Hard Copy No"
		,'' AS "BP PAN NO"
		,SUM(T1."LineTotal") AS "Befor Disc"
		,T0."DiscSum" AS "Discount"
		,(
			CASE 
				WHEN T0."CANCELED" = 'C'
					THEN - (
							ISNULL((
									SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
									FROM INV1
									WHERE T0."DocEntry" = INV1."DocEntry"
										AND T0."VatSum" > 0
									), 0)
							)
				ELSE ISNULL((
							SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
							FROM INV1
							WHERE T0."DocEntry" = INV1."DocEntry"
								AND T0."VatSum" > 0
							), 0)
				END
			) AS "Taxable Amount"
		,(
			CASE 
				WHEN T0."CANCELED" = 'C'
					THEN - (
							ISNULL((
									SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
									FROM INV1
									WHERE T0."DocEntry" = INV1."DocEntry"
										AND INV1."TaxCode" LIKE 'EX%'
										AND (
											T7."Country" = 'NP'
											OR T7."Country" IS NULL
											)
									), 0)
							)
				ELSE ISNULL((
							SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
							FROM INV1
							WHERE T0."DocEntry" = INV1."DocEntry"
								AND INV1."TaxCode" LIKE 'EX%'
								AND (
									T7."Country" = 'NP'
									OR T7."Country" IS NULL
									)
							), 0)
				END
			) AS "EXEMPT Amount"
		,(
			CASE 
				WHEN T0."CANCELED" = 'C'
					THEN - (
							ISNULL((
									SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
									FROM INV1
									WHERE T0."DocEntry" = INV1."DocEntry"
										AND T7."Country" <> 'NP'
									), 0)
							)
				ELSE (
						ISNULL((
								SELECT (SUM(INV1."LineTotal") - T0."DiscSum")
								FROM INV1
								WHERE T0."DocEntry" = INV1."DocEntry"
									AND T7."Country" <> 'NP'
								), 0)
						)
				END
			) AS "EXEMPT EXPORT"
		,(
			CASE 
				WHEN T0."CANCELED" = 'C'
					THEN - (ISNULL(T0."VatSum", 0))
				ELSE (ISNULL(T0."VatSum", 0))
				END
			) AS "VatSum"
		,(
			CASE 
				WHEN T0."CANCELED" = 'C'
					THEN - T0."DocTotal"
				ELSE T0."DocTotal"
				END
			) AS "DocTotal"
		,T1."WhsCode"
		,T5."Location"
		,'' AS "U_ReasonRet"
		,(CAST(FLOOR(T0."DocTime" / 100) AS VARCHAR) + ':' + CAST(RIGHT(T0."DocTime", 2) AS VARCHAR)) AS DocTime
		--,T0."Printed"
		,T7."U_NAME"
		,[dbo].ITN_NEPALI_FMT_DATE (T0.U_ITN_NPDate)   AS "Sales Miti"
		---,SUBSTRING(T0."U_ITN_NPDate", 0, 4) || '/' || SUBSTRING(T0."U_ITN_NPDate", 5, 2) || '/' || SUBSTRING(T0."U_ITN_NPDate", 7, 2) AS "Sales Miti"
	FROM OINV T0
	INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
	LEFT OUTER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
	LEFT OUTER JOIN CRD1 T10 ON T10."CardCode" = T2."CardCode"
	LEFT OUTER JOIN OCRG t3 ON T2."GroupCode" = t3."GroupCode"
	LEFT OUTER JOIN OLCT T5 ON T5."Code" = T1."LocCode"
	LEFT OUTER JOIN NNM1 t6 ON t6."Series" = t0."Series"
	LEFT OUTER JOIN OUSR T7 ON T0."UserSign" = T7."USERID"
	GROUP BY T0."DocEntry"
		,T0."DocNum"
		,T0."DocDate"
		,T0."CardCode"
		,T0."CardName"
		,T0."VatSum"
		,T0."DiscSum"
		,T0."DocTotal"
		,T1."WhsCode"
		,T2."CardFName"
		,T0."NumAtCard"
		,T5."Location"
		,t6."SeriesName"
		,T10."Country"
		,T0."ObjType"
		,T0."PIndicator"
		,T0."DocTime"
		,T0."Printed"
		,T0."DocStatus"
		,T7."U_NAME"
		,T0."CANCELED"
		,T7."Country"
		,T1."BaseRef"
		,T0."U_ITN_NPDate"
		,T0.U_ITN_Print_Count
		,T0."Printed"
		,CAST(T0."U_ITN_Is_Synced" AS nvarchar)
		,CAST(T0."U_ITN_Is_RealTime" AS nvarchar);
END
