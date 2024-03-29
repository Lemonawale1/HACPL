USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[ITN_BatchWise_Delivery]    Script Date: 31/07/2019 9:51:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCeDUre [dbo].[ITN_BatchWise_Delivery] (@Dockey INT)
AS
BEGIN

SELECT 
	T0.Docnum
	,T1.Quantity
	,T4.U_ITN_REGNO AS RegNo
	,t4.LotNumber as WorkOrderNo
	,T4.DistNumber as ChassisNo
   ,t4.MnfDate
   ,t4.MnfSerial as EngineNo
   ,I1.BaseLinNum
   ,t4.Notes as BatteryNo 
   ---,t4.U_ITN_CLR as Colour
   ,UF.Descr AS "Colour"
FROM ODLN T0
INNER JOIN DLN1 T1 ON T0.DocEntry = T1.DocEntry
LEFT  JOIN SRI1 I1 ON T1.ItemCode = I1.ItemCode
	AND (
		T1.DocEntry = I1.BaseEntry
		AND T1.ObjType = I1.BaseType
	)	
and t1.LineNum=i1.BaseLinNum
LEFT JOIN OSRN T4 ON T4.ItemCode = I1.ItemCode
	AND I1.SysSerial = T4.SysNumber
LEFT  JOIN UFD1 UF ON UF.FldValue=T4.U_ITN_CLR
AND UF.TableID='OSRN'
LEFT JOIN CUFD CU ON CU.FieldID=UF.FieldID
AND CU.AliasID='ITN_CLR'
and CU.TableID='OSRN'
where t1.DocEntry=@Dockey;
END	
