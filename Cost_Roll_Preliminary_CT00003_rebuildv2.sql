INSERT INTO CT00003 (CMPANYID,ITEMNMBR, 
ITEMDESC, 
ITMCLSCD,
MODIFDT, 
MDFUSRID,
COST_I, 
EFFECTIVEDATE_I, 
FIXAMTORPCT_I, 
Fixed_Overhead_Amount, 
FIXOHDPCT_I, 
FIXOHDEFFDATE_I, 
VARAMTORPCT_I, 
Variable_Overhead_Amount,
VAROHDPCT_I, 
VAROHDEFFDATE_I,
PENDINGCOST_I,
PENDEFFDATE_I, 
PENDFIXAMTORPCT_I,
PENDFIXOHDAMT_I,
PENDFIXOHDPCT_I,
PENDFIXOHDEFFDATE_I,
PENDVARAMTORPCT_I, 
PENDVAROHDAMT_I,
PENDVAROHDPCT_I, 
PENDVAROHDEFFDATE_I)

 
SELECT 1,ITEMNMBR,
ITEMDESC,
ITMCLSCD,
'1900-01-01 00:00:00.000',
'sa',
STNDCOST,
'1900-01-01 00:00:00.000',
0,
0,
0,
'1900-01-01 00:00:00.000',
0,
0,
0,
'1900-01-01 00:00:00.000',
0,
'1900-01-01 00:00:00.000',
0,
0,
0,
'1900-01-01 00:00:00.000',
0,
0,
0,
'1900-01-01 00:00:00.000'
--select * 
FROM tpspt.dbo.IV00101
where ITEMNMBR not in (select ITEMNMBR from CT00003)