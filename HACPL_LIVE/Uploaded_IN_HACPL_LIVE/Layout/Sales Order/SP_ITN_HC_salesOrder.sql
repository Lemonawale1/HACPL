USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_HC_salesOrder]    Script Date: 31/07/2019 9:51:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_ITN_HC_salesOrder] (@DocKey INT)
AS
  BEGIN
 
 SELECT T0."DocEntry"
		
			
			,CONCAT(ISNULL(T20."BeginStr", '')
			 , CAST(T0."DocNum" AS nvarchar) 
			 , ISNULL(CAST(T20."EndStr" AS CHAR(20)), '')) AS "SONumber"
			,T0."CardCode"   AS "CustomerCode"
			,T0."CardName"   AS "CustomerName"
			,T0."Address2"   AS "CustomerAddress"
			,T0."Address"    AS "CustomerBilToAdrs"			
			,T0."DocDate"    AS "PostingDate"
			,T0."DocDueDate" AS "DeliveryDate"
			,T0."TaxDate"	 AS "DocumentDate"
			--,CONCAT(SUBSTRING(T0."U_ITN_NPDate",0,4)
			-- ,'/',SUBSTRING(T0."U_ITN_NPDate",5,2)
			-- ,'/',SUBSTRING(T0."U_ITN_NPDate",7,2)) AS Miti
			,[dbo].ITN_NEPALI_FMT_DATE (T0.U_ITN_NPDate) as "Miti"
			,OADM."CompnyName" AS "CompanyName"
			,OADM."CompnyAddr" AS "CompanyAddress"
			,ADM1."Building" AS "CompanyBuilding"
			,ADM1."Block" AS "CompanyBlock"
			,ADM1."Street" AS "CompanyStreet"
			,ADM1."StreetNo"  AS "CompanyPoBoX"
			,ADM1."City"  AS "CompanyCity"
			,ADM1."ZipCode"  AS "CompanyZipCode"
			,OADM."RevOffice" AS "CompanyPAN"
			,OADM."Phone1" AS "CompanyPhone"
			,OADM."Phone2" AS "Mobile"
			,OADM."Fax" AS "CompanyFax"
			,OADM."E_Mail" AS "CompanyEmail"
			,OADM."Country" AS "CompanyCountryName"
			,ST2."Name" AS "ComStateName"
			,T0."OwnerCode" AS "PreparedBy"
			,ISNULL(CAST(AD."Building" AS VARCHAR), '') AS "CustomerBuilding"
			,ISNULL(AD."City", '') AS "CustomerCity"
			,ISNULL(ST."Name", '') AS "CustomerState"
			,ISNULL(AD."ZipCode", '') AS "CustomerZipCode"
			,ISNULL(AD."Country", '') AS "CustomerCountry"
			,T17."Name" AS "CustCountryName"
			,ISNULL(CAST(AD1."Street" AS VARCHAR), '') AS "CustomerBuildingS"
			,ISNULL(AD1."City", '') AS "CustomerCityS"
			,ISNULL(ST1."Name", '') AS "CustomerStateS"
			,ISNULL(AD1."ZipCode", '') AS "CustomerZipCodeS"
			,ISNULL(AD1."Country", '') AS "CustomerCountryS"
			--,T4."U_ITN_ITMB" AS "Brand"
			,OUSR."U_NAME" AS "USER_CODE"
		 	,T1."ItemCode" As "Product Code"
		 	,T1."Dscription" As "Product Name"
		 	,T1."Quantity"
		 	,T1."unitMsr" As "Uom"
			,T1."Price" As "UnitPrice"
			,ISNULL(M."Name", '') AS "CustContName"
			,ISNULL(T16."Phone1", '') AS "CustContMobileNo"
			,ISNULL(M."Tel1" , '')    AS "CustContTel"
			,ISNULL(T16."E_Mail", '')  AS "CustContEmail"
			,T3."TaxId4"  AS "CustomerPAN"
			,T3."TaxId1"  AS "CustomerCSTNo"
			,T3."TaxId2"  AS "CustomerLSTNo"
			,T3."TaxId11" AS "CustomerTINNo"
	FROM ORDR T0
	INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
	LEFT JOIN OADM OADM ON 1 = 1
	LEFT JOIN ADM1 ADM1 ON ADM1."Code" = OADM."Code"
	LEFT JOIN OCRD T16 ON T16."CardCode" = T0."CardCode"
	LEFT JOIN OUSR ON T0."UserSign" = OUSR."USERID"
	INNER JOIN NNM1 T20 ON T20."Series" = T0."Series"
	LEFT JOIN CRD7 T2 ON T2."CardCode" = T0."CardCode"
		AND T2."Address" = T0."ShipToCode"
		AND T2."AddrType" = 'S'
	LEFT JOIN CRD7 T3 ON T3."CardCode" = T0."CardCode"
		AND T3."Address" = ''
		AND T3."AddrType" = 'S'
	LEFT JOIN OITM T4 ON T4."ItemCode" = T1."ItemCode"
	LEFT JOIN OCTG T9 ON T9."GroupNum" = T0."GroupNum"
	LEFT JOIN OCRN T12 ON T0."DocCur" = T12."CurrCode"
	LEFT JOIN RDR12 T13 ON T13."DocEntry" = T1."DocEntry"
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
    --LEFT JOIN V_ITN_ITEMORD Pivot ON Pivot."ItemCode" = T4."ItemCode"
    --AND Pivot."DocEntry" = T0."DocEntry"
    LEFT JOIN OCRY T17 ON T17."Code" = AD."Country"
    LEFT JOIN OCST ST2 ON ST2."Code" = OADM."State"
		AND ST2."Country" = OADM."Country"	
    WHERE T0."DocEntry" = @DocKey
	
                END
