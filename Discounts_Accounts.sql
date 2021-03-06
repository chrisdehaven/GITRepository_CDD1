/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      sum([Credit Amount]-[Debit Amount])
     
  FROM [TPSPT].[dbo].[AccountSummary]
  
  where [Account Index] in(205,
209,
210,
588,
1204,
1205,
1206,
1208,
1209,
1210,
1211,
1212,
1213,
1215,
1216,
1217,
1239,
1240,
1241,
1243,
1244,
1245)

and YEAR=2014 and [Period ID]=8