/****** Script for SelectTopNRows command from SSMS  ******/
SELECT LSTUSRED , 
       CREATDDT , 
       MODIFDT , 
       CMPANYID , 
       CMPNYNAM , 
       INTERID
  FROM DYNAMICS.dbo.SY01500
  ORDER BY CREATDDT;