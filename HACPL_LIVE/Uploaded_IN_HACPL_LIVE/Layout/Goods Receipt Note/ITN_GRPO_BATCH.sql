USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[ITN_GRPO_BATCH]    Script Date: 31/07/2019 9:51:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCeDUre [dbo].[ITN_GRPO_BATCH] (@Dockey INT)
AS
BEGIN
SELECT 
	 r.BaseLinNum
	,r1.MnfDate MfgDate
	,r1.MnfSerial EngineNumber
	,r1.DistNumber ChassisNo
	,r1.Notes BatteryNo
    ,r1.LotNumber RegNo
    ,UF.Descr AS COLOUR
    ,r1."InDate" as "AdmissionDate"
    ,R1.LotNumber AS "WorkOrderNo"
FROM sri1 r
INNER JOIN OSRN r1 ON r1.SysNumber = r.SysSerial
	AND r1.ItemCode = r.ItemCode
INNER JOIN pdn1 n1 ON n1.DocEntry = r.BaseEntry
	AND n1.ItemCode = r.ItemCode
	AND n1.LineNum = r.BaseLinNum
INNER JOIN opdn n ON n.DocEntry = n1.DocEntry
LEFT OUTER JOIN opor pr ON pr.docentry = n1.baseentry
	AND n1.basetype = '22'
	
LEFT  JOIN UFD1 UF ON UF.FldValue=R1.U_ITN_CLR
AND UF.TableID='OSRN'
LEFT JOIN CUFD CU ON CU.FieldID=UF.FieldID
AND CU.AliasID='ITN_CLR'
and CU.TableID='OSRN'
WHERE N.DocEntry=@DocKey;
END
