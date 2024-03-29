USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[ITN_GETBATCHDETAILS]    Script Date: 31/07/2019 9:51:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[ITN_GETBATCHDETAILS] (@RefNum int)
AS
BEGIN
	SELECT T0.LotNumber
		,T0.MnfSerial
		,T0.DistNumber
	FROM OSRN T0
	LEFT JOIN SRI1 T1 ON T1.SysSerial = T0.SysNumber
		AND T1.ItemCode = T0.ItemCode
	LEFT JOIN OIGE T2 ON T2.DocNum = T1.BaseNum
		AND T2.ObjType = T1.BaseType
	WHERE T2.DocNum = @RefNum;
END
