USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_HC_salesReturn]    Script Date: 31/07/2019 9:51:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[SP_ITN_HC_salesReturn] (@DocKey INT)
AS
BEGIN
	SELECT T0."DocEntry"
		,T0."CardCode"
		,T0."CardName"
		,T18."Phone1" AS "Phone"
		,T19."GlblLocNum" AS "CIN No"
		,T19."StreetNo" AS "Corp. Office"
		,T19."Block" AS "Regd. Addres"
		,T19."STDCode" AS "STD Code"
		,T18."RevOffice" AS "PAN NO"
		,T18."FreeZoneNo" AS "VAT/CST/TIN No"
		,T18."CompnyName"
		,T18."CompnyAddr"
		,T18."RevOffice"
		,T0."Address2" AS "Address"
		,T0."Address" AS "BilToAdrs"
		,T0."DocTotal"
		,'' AS "NoOfPkgs"
		,'' AS "CntPerPack"
		,T0."NumAtCard" AS "PONo"
		,CONCAT(ISNULL(T21."BeginStr", '') , CAST(OINV."DocNum" AS nvarchar) , CAST(T21."EndStr" AS nvarchar)) AS "OrderNo"
		,OINV."DocDate" AS "OrderDT"
		,[dbo].[ITN_NEPALI_FMT_DATE](OINV."U_ITN_NPDate")AS "OrdrNpDt"
		--,CONCAT(SUBSTRING(OINV."U_ITN_NPDate", 0, 4) ,'/' , SUBSTRING(OINV."U_ITN_NPDate", 5, 2) , '/' , SUBSTRING(OINV."U_ITN_NPDate", 7, 2)) AS "OrdrNpDt"
		,'' AS "CntyOfDsch"
		,CONCAT(ISNULL(T20."BeginStr", '') ,  CAST(T0."DocNum" AS nvarchar) , CAST(T20."EndStr" AS nvarchar)) AS "InvNo"
		,T0."DocDate" AS "InvDt"
		,T1."ItemCode" AS "ItemCode"
		,T1."Dscription" AS "Dscription"
		,T1."Quantity" AS "Quantity"
		,T1."unitMsr" AS "UoM"
		,T0."OwnerCode" AS "PreparedBy"
		,T1."PriceBefDi" AS "Price"
		,(ISNULL(T1."Quantity", 0) * ISNULL(T1."PriceBefDi", 0)) AS "LineAmt"
		,T1."LineTotal"
		,T2."TaxId8" AS "ECCNo"
		,T2."CERange"
		,T0."VatSum"
		,T2."CEDivis"
		,T2."CEComRate"
		,T1."LineNum" AS "Line No"
		,T3."TaxId4" AS "PANNo"
		,T3."TaxId1" AS "CSTNo"
		,T3."TaxId2" AS "LSTNo"
		,T3."TaxId11" AS "TINNo"
		,T5."ChapterID"
		,T5."Dscription" AS "ChIdDes"
		,T9."PymntGroup" AS "PaymntMethd"
		,ISNULL(T0."WTSum", 0) AS "TCS"
		,T0."RoundDif" AS "RoundOf"
		,T12."CurrName" AS "CurrName"
		,T1."VatPrcnt" AS "TAXRATE"
		,T12."F100Name" AS "CurrName2"
		,T13."TransCat" AS "SalAgstFrm"
		,T1."DiscPrcnt" AS "LineDisc"
		,T15."Building" AS "BrBuilding"
		,T15."City" AS "BrCty"
		,T15."State" AS "BrState"
		,T15."ZipCode" AS "BrZpCod"
		,ISNULL(CAST(AD."Building" AS VARCHAR), '') AS "Building"
		,ISNULL(AD."City", '') AS "City"
		,ISNULL(ST."Name", '') AS "State"
		,ISNULL(AD."ZipCode", '') AS "ZipCode"
		,ISNULL(AD."Country", '') AS "Country"
		,ISNULL(CAST(AD1."Street" AS VARCHAR), '') AS "BuildingS"
		,ISNULL(AD1."City", '') AS "CityS"
		,ISNULL(ST1."Name", '') AS "StateS"
		,ISNULL(AD1."ZipCode", '') AS "ZipCodeS"
		,ISNULL(AD1."Country", '') AS "CountryS"
		,L."LstVatNo"
		,L."CstNo"
		,T0."DiscPrcnt" AS "DiscntPct"
		,T0."DiscSum"
		,T0."TotalExpns"
		,OUSR."U_NAME" AS "USER_CODE"
		,CASE 
			WHEN T0."TotalExpns" < '0'
				THEN T0."TotalExpns" * (- 1)
			ELSE T0."TotalExpns"
			END AS "frt"
		,((ISNULL(T1."PriceBefDi", 0) - ISNULL(T1."Price", 0)) * ISNULL(T1."Quantity", 0)) AS "DisAmt"
		,ISNULL(M."Cellolar", '') AS "MobileNo"
		,ISNULL(M."Tel1", '') AS "Tel"
		,T1."VatPrcnt"
		,T16."Balance"
		,T0."PeyMethod" AS "PaymentMode"
		,[dbo].[ITN_NEPALI_FMT_DATE](T0."U_ITN_NPDate") "NP Date"
		--,CONCAT(SUBSTRING(T0."U_ITN_NPDate", 0, 4) , '/' , SUBSTRING(T0."U_ITN_NPDate", 5, 2) , '/' ,SUBSTRING(T0."U_ITN_NPDate", 7, 2)) AS "NP Date"
		,T0."VatSum"
	FROM ORIN T0
	INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
	LEFT JOIN OADM T18 ON 1 = 1
	LEFT JOIN ADM1 T19 ON T18."Code" = T19."Code"
	LEFT JOIN OCRD T16 ON T16."CardCode" = T0."CardCode"
	LEFT JOIN OUSR ON T0."UserSign" = OUSR."USERID"
	INNER JOIN NNM1 T20 ON T20."Series" = T0."Series"
	LEFT JOIN CRD7 T2 ON T2."CardCode" = T0."CardCode"
		AND T2."Address" = T0."ShipToCode"
		AND T2."AddrType" = 'S'
	LEFT JOIN CRD7 T3 ON T3."CardCode" = T0."CardCode"
		AND T3."Address" = ''
		AND T3."AddrType" = 'S'
	LEFT JOIN OITM T4 ON T4."ItemCode" = T1."ItemCode" --AND T1."ObjType" = '16'
	LEFT JOIN OCHP T5 ON T5."AbsEntry" = T4."ChapterID"
	LEFT JOIN INV1 T7 ON T1."DocEntry" = T7."TrgetEntry"
		AND T7."ObjType" = T1."BaseType"
		AND T7."LineNum" = T1."BaseLine"
	LEFT JOIN OINV ON T7."DocEntry" = OINV."DocEntry"
	LEFT JOIN NNM1 T21 ON T21."Series" = OINV."Series"
	LEFT JOIN DLN1 T6 ON T1."DocEntry" = T6."TrgetEntry"
		AND T6."ObjType" = T1."BaseType"
		AND T6."LineNum" = T1."BaseLine"
	LEFT JOIN ODLN ON T6."DocEntry" = ODLN."DocEntry"
	LEFT JOIN RDR1 T23 ON T6."DocEntry" = T23."TrgetEntry"
		AND T23."ObjType" = T6."BaseType"
		AND T23."LineNum" = T6."BaseLine"
	LEFT JOIN ORDR ON T23."DocEntry" = ORDR."DocEntry"
	LEFT JOIN OCTG T9 ON T9."GroupNum" = T0."GroupNum"
	LEFT JOIN OCRN T12 ON T0."DocCur" = T12."CurrCode"
	LEFT JOIN RIN12 T13 ON T13."DocEntry" = T1."DocEntry"
	LEFT JOIN OWHS T15 ON T1."WhsCode" = T15."WhsCode"
	LEFT JOIN OLCT L ON L."Code" = T15."Location"
	LEFT JOIN CRD1 AD ON AD."CardCode" = T0."CardCode"
		AND AD."Address" = T0."PayToCode"
		AND AD."AdresType" = 'B'
	LEFT JOIN OCST ST ON ST."Code" = AD."State"
		AND ST."Country" = AD."Country"
	LEFT JOIN CRD1 AD1 ON AD1."CardCode" = T0."CardCode"
		AND AD1."Address" = T0."ShipToCode"
		AND AD1."AdresType" = 'S'
	LEFT JOIN OCST ST1 ON ST1."Code" = AD1."State"
		AND ST1."Country" = AD1."Country"
	LEFT JOIN OCPR M ON M."CntctCode" = T0."CntctCode"
		AND M."CardCode" = T0."CardCode"
	WHERE T0."DocEntry" = @DocKey;
	
	
END




