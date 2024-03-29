USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_OutgoingInvoicePmt]    Script Date: 31/07/2019 9:52:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_ITN_OutgoingInvoicePmt](@DocKey INT)
----Get Ap InvoiceNo Of OutgoingPayment from this Procedure
	AS
	BEGIN
SELECT
	OP."DocNum" as "ApDocNo"
	,case 
	   when OP."DocNum" IS NULL then
	   ''
	   else
	CONCAT(ISNULL(T4."BeginStr", '') , CAST(OP."DocNum" AS nvarchar) , CAST(T4."EndStr" AS CHAR(20))) 
	end AS "A/P_INVOICE"
	,CASE WHEN OP."DocNum" IS NULL THEN ''
	ELSE
	 CAST(OP."DocTotal" AS nvarchar) END as "A/P_InvoiceAmt"
	,[dbo].ITN_NEPALI_FMT_DATE (OP."U_ITN_NPDate") as "InvoiceNPdate"
FROM  OVPM T2
LEFT JOIN NNM1 T4 ON T4."Series" = T2."Series"
LEFT JOIN VPM4 T10 ON T10."DocNum" = T2."DocEntry"
	left join VPM2 VP ON VP."DocNum"=T2."DocEntry"
LEFT JOIN OPCH OP ON OP."DocEntry" =VP."DocEntry"
where T2."DocEntry"=@DocKey;
END
