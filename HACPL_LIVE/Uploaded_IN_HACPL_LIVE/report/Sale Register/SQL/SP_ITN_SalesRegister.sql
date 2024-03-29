USE [HACPL_LIVE]
GO
/****** Object:  StoredProcedure [dbo].[SP_ITN_SalesRegister]    Script Date: 31/07/2019 9:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ITN_SalesRegister]
AS
BEGIN

with TX as(
select T2.DocEntry, T2.Linenum, 
Sum(T2."TaxSum") as "Vat" 
,Sum(T2."TaxSum") as "TotalTax" 

from INV1 T1 join INV4 T2
on T1.DocEntry = T2.DocEntry
and T1.LineNum = T2.LineNum
group by T2.DocEntry, T2.LineNum
)

select T0.DocDate, T0.CardName, T0.DocNum, T1.ItemCode, T1.UomCode, T1.Quantity
,T1.Price, T1.LineTotal
,sum(T1.LineTotal) over(partition by T0.DocEntry) TotalVATable
,sum(TX.TotalTax) over(partition by T0.DocEntry) TotalTax
,T0.DocTotal

from OINV T0
join 
INV1 T1 
on T0.DocEntry = T1.DocEntry

join
TX on T1.DocEntry = TX.DocEntry and T1.LineNum = TX.LineNum
;

End





--select * from inv1 where DocEntry=71--DocNum = '100066'

