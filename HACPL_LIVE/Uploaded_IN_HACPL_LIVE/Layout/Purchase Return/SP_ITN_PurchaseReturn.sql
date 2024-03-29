USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_PurchaseReturn]    Script Date: 31/07/2019 9:52:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_ITN_PurchaseReturn] (@DocKey INT)
AS
BEGIN
	SELECT T1."DocEntry"
		,T1."DocNum"
		,CAST(NM.SeriesName AS nvarchar) + '/'+ CAST(T1.DocNum AS nvarchar) AS Rno
		,T1."DocDate" AS "DocDate"
		,T1."TaxDate" AS "TaxDate"
		,T1."DocDueDate" AS "DocDueDate"
		,T1."CardCode"
		---, case when OC."Phone1"='' THEN OC.Phone2 else oc.Phone1  END AS "VendorPhone"
		,isnull(oc.Phone1,OC.Phone2) as "VendorPhone"
		,T1."CardName"
		,T1."Confirmed"
		,T1."DocCur" AS "CURRENCY"
		,T1."DocRate" AS "CURRENCY_RATE"
		,T1."DocDueDate" AS "Delivery Date"
		,T4."Vendor_PAN"
		,T4."Vendor_VAT"
		,T4."Vendor_TIN"
		,T4."Vendor_CST"
		,T1."Address" AS "Vendor_ADDRESS"
		,T5."TinNo" AS "LocTin"
		,T5."PanNo" AS "LocPAN"
		,T5."CstNo" AS "LocCstNo"
		,T15."TrnspName"
		,T5."EccNo" AS "EXCISE_NO"
		,T5."Street" AS "LOC_Street"
		,T5."Block" AS "Loc_Block"
		,T5."Building" AS "Loc_Building"
		,T5."City" AS "Loc_City"
		,T5."ZipCode" AS "Loc_ZipCode"
		--,'India' AS "LOC_country"
		,T1."CANCELED"
		,OPQ."DocNum" AS "Invoice No."
		,OPQ."NumAtCard" AS "INV Ref. No."
		,OPQ."TaxDate" AS "Vendor INV Ref Date"
		,Z."SHIP_BLOCK"
		,Z."SHIP_BUILDING"
		,Z."SHIP_STREET"
		,Z."SHIP_CITY"
		,Z."SHIP_ZIPCODE"
		,Z."SHIP_StateName"
		--,Z."Country"
		,T1."DiscPrcnt" as "DocumentDiscPrcnt"
		,T2."DiscPrcnt" as "LineItemDiscPrcnt"
		,T1."DiscSum"
		,T1."VatSum"
		 ,[dbo].ITN_NEPALI_FMT_DATE (T1.U_ITN_NPDate) AS "ReturnMiti"
		,CASE ISNULL(CAST(T12."TransCat" AS VARCHAR(10)), '')
			WHEN ''
				THEN ''
			ELSE 'SALE AGAINST ' + CAST(T12."TransCat" AS VARCHAR(10))
			END AS "FormType"
		,T12."FormNo"
		,T1."TrackNo" AS "DispatchNo"
		,T1."NumAtCard" AS "RefNo"
		,T6."PymntGroup" AS "PaymentTerm"
		,T3."Name"
		,T2."ItemCode"
		,T2."Dscription"
		,T2."Quantity"
		,T2."VatSum" AS "TaxAmount"
		,OS."Name" AS "TaxName"
		,OT."UserText"
		,CASE 
			WHEN T2."Quantity" = T2."PackQty"
				THEN NULL
			ELSE T2."PackQty"
			END AS "NoofPack"
		,T2."PriceBefDi"
		,T2."unitMsr"
		,T2."LineTotal" as  "LineItemSum"
		,T13."Substitute"
		,T1."DocTotal"
		,T1."Comments" AS "Remark"
		,T1."RoundDif"
		,OADM."CompnyName"
		,OADM."CompnyAddr"
		,OADM."Phone1"
		,OADM."FreeZoneNo"
	FROM ORPC T1
	INNER JOIN RPC1 T2 ON T1."DocEntry" = T2."DocEntry"
	INNER JOIN OSTC OS ON T2."TaxCode" = OS."Code"
	INNER JOIN OITM OT ON T2."ItemCode" = OT."ItemCode"
	LEFT OUTER JOIN OCPR T3 ON T1."CntctCode" = T3."CntctCode"
	LEFT OUTER JOIN NNM1 NM ON NM."Series" = T1."Series"
	LEFT OUTER JOIN PCH1 PQ ON T2."ItemCode" = PQ."ItemCode"
		AND T2."LineNum" = PQ."BaseLine"
		AND T2."BaseEntry" = PQ."DocEntry"
	LEFT OUTER JOIN OPCH OPQ ON PQ."DocEntry" = OPQ."DocEntry"
	LEFT OUTER JOIN (
		SELECT "TaxId0" AS "Vendor_PAN"
			,"TaxId2" AS "Vendor_VAT"
			,"TaxId11" AS "Vendor_TIN"
			,"TaxId1" AS "Vendor_CST"
			,"CardCode"
		FROM CRD7
		WHERE ISNULL("Address", '') = ''
			AND "AddrType" = 'S'
		) T4 ON T1."CardCode" = T4."CardCode"
	LEFT OUTER JOIN POR12 T12 ON T1."DocEntry" = T12."DocEntry"
	INNER JOIN OLCT T5 ON T2."LocCode" = T5."Code"
	LEFT OUTER JOIN OCTG T6 ON T1."GroupNum" = T6."GroupNum"
	LEFT OUTER JOIN OSCN T13 ON T1."CardCode" = T13."CardCode"
		AND T2."ItemCode" = T13."ItemCode"
	LEFT OUTER JOIN (
		SELECT A."WhsCode"
			,A."Street" AS "SHIP_STREET"
			,A."Block" AS "SHIP_BLOCK"
			,A."Building" AS "SHIP_BUILDING"
			,A."City" AS "SHIP_CITY"
			,A."ZipCode" AS "SHIP_ZIPCODE"
			,B."Name" AS "SHIP_StateName"
			--,'India' AS "Country"
		FROM OWHS A
			,OCST B
		WHERE A."State" = B."Code"
			AND A."Country" = B."Country"
		) Z ON T2."WhsCode" = Z."WhsCode"
	LEFT OUTER JOIN OSHP T15 ON T1."TrnspCode" = T15."TrnspCode"
	INNER JOIN OADM ON 1 = 1
	LEFT JOIN ADM1 ON OADM."Code" = ADM1."Code"
	left join OCRD OC ON OC.CardCode=T1.CardCode
	
	WHERE T1."DocEntry"= @DocKey;
	
END
