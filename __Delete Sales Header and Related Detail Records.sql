use TPSPT

declare @sopnumbe varchar(30)
set @sopnumbe ='ORD664343'

--SELECT * from SY00500 where soBACHNUMB = @username
SELECT sopnumbe,* from SOP10100 where sopnumbe = @sopnumbe 
SELECT * FROM  SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe)
SELECT * FROM SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe) 

--DELETE SY00500 where BACHNUMB = @username
DELETE SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe)
DELETE SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe) 
DELETE SOP10100 where sopnumbe = @sopnumbe

