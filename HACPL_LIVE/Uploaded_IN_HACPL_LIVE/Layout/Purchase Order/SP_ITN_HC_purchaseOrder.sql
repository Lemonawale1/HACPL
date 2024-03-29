USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_HC_purchaseOrder]    Script Date: 31/07/2019 9:51:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[SP_ITN_HC_purchaseOrder](@DocKey INT)
AS
BEGIN
SELECT T0."DocEntry"
	,CONCAT(ISNULL(T4."BeginStr", '') 
	 , CAST(T0."DocNum" AS nvarchar) 
	 , ISNULL(CAST(T4."EndStr" AS CHAR(20)), '')) AS "PurOrdNo"
	,T0."DocDate" AS "PurOrdDt"
     ,[dbo].ITN_NEPALI_FMT_DATE (T0.U_ITN_NPDate) AS Miti 
	--,CONCAT(SUBSTRING(T0."U_ITN_NPDate",0,4),'/',SUBSTRING(T0."U_ITN_NPDate",5,2),'/',SUBSTRING(T0."U_ITN_NPDate",7,2)) AS Miti 
	,T0."DocCur" AS "DocumentCurrency"
	,CASE 
		WHEN T0."DocStatus" = 'C'
			THEN 'Closed'
		ELSE 'Open'
		END AS "Status"
	,T0."UpdateDate" AS "POModifyDt"
	,T0."CardCode" AS "VendorCode"
	--,T0."CardName" AS "VendorName" 
	,T11."CardName"
	,T0."Address" AS "VendorBillingAddress"
	,T13."Street" AS "VendorStreet"
	,T13."City" AS "VendorCity"
	,T13."ZipCode" AS "VendorZipCode"
	,T13."Country" AS "VendorCountry"
	,T12."TaxId2" AS "VendorPAN"
	,T11."E_Mail" AS "VendorEmail"
	,T11."Phone1" AS "VendorPhone"
	,T11."Fax" AS "VendorFax"
	,T8."Name" AS "VendorContactPerson" -- ,T8.Title + ' ' + T8."FirstName" + ' ' + T8."MiddleName" + ' ' + T8."LastName"
	,T8."Cellolar" AS "VendorContactPhone"
	
	,T0."Address2" AS "ShippingAddress"
	,CONCAT(ISNULL(T29."BeginStr", '') 
	, CAST(RH."DocNum" AS nvarchar) 
	,ISNULL(CAST(T29."EndStr" AS CHAR(20)), '')) AS "RequisitionNum"
	,RH."ReqName" AS "RequesterName"
	,RH."DocDate" AS "ReqDate"
	,[dbo].ITN_NEPALI_FMT_DATE (RH.U_ITN_NPDate) AS "ReqMiti"
	--,CONCAT(SUBSTRING(RH."U_ITN_NPDate",0,4),'/',SUBSTRING(RH."U_ITN_NPDate",5,2),'/',SUBSTRING(RH."U_ITN_NPDate",7,2)) AS "ReqMiti"
	,T0."DocDueDate" AS "DeliveryDate"
	,T1."ShipDate" AS "ItemDeliveryDate"
	,T5."TrnspName" AS "ShipType"
	,T14."CurrName" AS "CurrencyName"
	,T1."ItemCode" AS "ItemCode"
	,CASE 
		WHEN T1."Text" IS NULL
			THEN T1."Dscription"
		ELSE T1."Text"
		END AS "ItemName"
	,T1."unitMsr" AS "ItemUOM"
	,T1."Quantity" AS "Quantity"
	,T1."PriceBefDi" AS "Price"
	,T1."DiscPrcnt" AS "LineDiscountPercent"
	,(T1."Quantity" * T1."Price") AS "LineTotal"
	,T0."DiscPrcnt" AS "DocDiscPercent"
	,CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T0."DiscSum"
		ELSE T0."DiscSumFC"
		END AS "Doc Disc AMOUNT"
	,CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T0."VatSum"
		ELSE T0."VatSumFC"
		END AS "Doc VAT AMOUNT"
	,CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T0."DocTotal"
		ELSE T0."DocTotalFC"
		END AS "POTotal"
	--,T0."U_ITN_PYTM" AS "PaymentTerm"
	--,T0."U_ITN_DLTM" AS "DeliveryTerm" 
	--,OUSR."U_NAME"   AS "Doc_CreaterName"
	,T9."SlpName"    AS "BuyerName"
	--,T1."U_ITN_HSCD" AS "HSCode"
	--,T3."U_ITN_HSCD" AS "H.S.Code"
	--,T0."U_ITN_WRNT" AS "Warranty"
	--,T0."U_ITN_CNOR" AS "CountryofOrigin"
	--,T0."U_ITN_OTHC" AS "OtherConditon"
	--,T0."U_ITN_SHVA" AS "ShipVia"
	,T0."Comments"   AS "Comments"
	,T4."Remark"	 AS "Remarks"
	,T1."TaxCode"    AS "TAX CODE"
	,ISNULL((SELECT SUM(POR4."TaxSum")
     FROM POR4
     WHERE T0."DocEntry" = POR4."DocEntry"
	 AND POR4."staType" = 1), 0) AS "VatAmt"
	,T2."Building" AS "LocAdr"
	,T2."City" AS "LocCity"
	,T2."CompType" AS "LocEmail"
	,T2."AsseType" AS "LocPhn"
	,T4."Remark" AS "Division"
	,T0."DocCur" AS "Currency"
	,OUSR."U_NAME" AS "USER_Name"
	--,T0."U_ITN_PTOL" AS "Port of Landing"
	--,T0."U_ITN_PTOD" AS "Port of Discharge"
	--,T0."U_ITN_CUEP" AS "Custom Entry Point"
	--,T0."U_ITN_CONN" AS "Contract Number"
	,T0."U_ITN_MDPY"  as "Mode of Payment"
	,T0."U_ITN_MTRN"  as "Mode of Transport"
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T15."LineTotal"
		ELSE T15."TotalFrgn"
		END, 0) AS "FreightInclusive"
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T17."LineTotal"
		ELSE T17."TotalFrgn"
		END, 0) AS "TransitInsurance"
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T19."LineTotal"
		ELSE T19."TotalFrgn"
		END, 0) AS "PackingCharges"	
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T21."LineTotal"
		ELSE T21."TotalFrgn"
		END, 0) AS "Loading&Unloading"
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T23."LineTotal"
		ELSE T23."TotalFrgn"
		END, 0) AS "MiscExp"	
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T25."LineTotal"
		ELSE T25."TotalFrgn"
		END, 0) AS "FreightExclusive"	
	,ISNULL(CASE 
		WHEN T0."DocCur" = 'NPR'
			THEN T27."LineTotal"
		ELSE T27."TotalFrgn"
		END, 0) AS "CST"			
	,ISNULL(T16."ExpnsName", '')  AS "PACKAGEName"
	,ISNULL(T18."ExpnsName", '')  AS "FreightName"
	,CASE
		WHEN T1."TaxCode" = 'EXVAT'
		  THEN ISNULL(T1."U_ITN_EXPU", 0) * T1."Quantity" 
		ELSE ISNULL((SELECT SUM(POR4."TaxSum")
     		  		 FROM POR4
     		  		 WHERE T0."DocEntry" = POR4."DocEntry"
	 				 AND POR4."staType" = 7), 0)
	 				 END  AS "LineExcise"
	,((ISNULL(T1."PriceBefDi", 0) - ISNULL(T1."Price", 0)) * ISNULL(T1."Quantity", 0)) + T0."DiscSum" AS "DisAmt"
FROM OPOR T0
INNER JOIN POR1 T1 ON T0."DocEntry" = T1."DocEntry"
LEFT JOIN OLCT T2 ON T1."LocCode" = T2."Code"
LEFT JOIN OITM T3 ON T1."ItemCode" = T3."ItemCode"
LEFT JOIN NNM1 T4 ON T0."Series" = T4."Series"
LEFT JOIN OSHP T5 ON T0."TrnspCode" = T5."TrnspCode"
LEFT JOIN OCTG T6 ON T0."GroupNum" = T6."GroupNum"
LEFT JOIN OPYM T7 ON T0."PeyMethod" = T7."PayMethCod"
LEFT JOIN OCPR T8 ON T0."CntctCode" = T8."CntctCode"
LEFT JOIN OSLP T9 ON T0."SlpCode" = T9."SlpCode"
LEFT JOIN OSTC T10 ON t1."TaxCode" = T10."Code"
LEFT JOIN OCRN T14 ON T0."DocCur" = T14."CurrCode"
LEFT JOIN OCRD T11 ON T11."CardCode" = T0."CardCode"
LEFT JOIN POR12 T12 ON T12."DocEntry" = T0."DocEntry"
LEFT JOIN CRD1 T13 ON T13."CardCode" = T0."CardCode"
	AND T13."AdresType" = 'B'
LEFT JOIN OUSR ON T0."UserSign" = OUSR."USERID"
INNER JOIN OADM ON 1 = 1
LEFT JOIN ADM1 ON OADM."Code" = ADM1."Code"
LEFT JOIN PRQ1 RQ ON RQ."DocEntry" = T1."BaseEntry"
	AND RQ."ObjType" = T1."BaseType"
	AND RQ."LineNum" = T1."BaseLine"
LEFT JOIN OPRQ RH ON RH."DocEntry" = RQ."DocEntry"
LEFT JOIN OCST ST2 ON ST2."Code" = OADM."State"
	AND ST2."Country" = OADM."Country"
LEFT JOIN NNM1 T29 ON T29."Series" = RH."Series"
LEFT JOIN POR3 T15 ON T0."DocEntry" = T15."DocEntry"
	 AND T15."ExpnsCode" = 1
LEFT JOIN OEXD T16 ON T15."ExpnsCode" = T16."ExpnsCode"
	AND T16."ExpnsCode" = 1
LEFT JOIN POR3 T17 ON T0."DocEntry" = T17."DocEntry"
	 AND T17."ExpnsCode" = 2
LEFT JOIN OEXD T18 ON T17."ExpnsCode" = T18."ExpnsCode"
	AND T18."ExpnsCode" = 2
LEFT JOIN POR3 T19 ON T0."DocEntry" = T19."DocEntry"
	 AND T19."ExpnsCode" = 3
LEFT JOIN OEXD T20 ON T19."ExpnsCode" = T20."ExpnsCode"
	AND T20."ExpnsCode" = 3
LEFT JOIN POR3 T21 ON T0."DocEntry" = T21."DocEntry"
	 AND T21."ExpnsCode" = 4
LEFT JOIN OEXD T22 ON T21."ExpnsCode" = T22."ExpnsCode"
	AND T22."ExpnsCode" = 4
LEFT JOIN POR3 T23 ON T0."DocEntry" = T23."DocEntry"
	 AND T23."ExpnsCode" = 5
LEFT JOIN OEXD T24 ON T23."ExpnsCode" = T24."ExpnsCode"
	AND T24."ExpnsCode" = 5
LEFT JOIN POR3 T25 ON T0."DocEntry" = T25."DocEntry"
	 AND T25."ExpnsCode" = 6
LEFT JOIN OEXD T26 ON T25."ExpnsCode" = T26."ExpnsCode"
	AND T26."ExpnsCode" = 6
LEFT JOIN POR3 T27 ON T0."DocEntry" = T27."DocEntry"
	 AND T27."ExpnsCode" = 7
LEFT JOIN OEXD T28 ON T27."ExpnsCode" = T28."ExpnsCode"
	AND T28."ExpnsCode" = 7 
WHERE T0."DocType" = 'I'
AND T0."DocEntry" = @DocKey;
END
