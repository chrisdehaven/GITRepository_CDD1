use TPSPT
use tpeur
go
declare @sopnumbe varchar(30)
set @sopnumbe ='ORD107075'

SELECT sopnumbe,* from SOP10100 where sopnumbe = @sopnumbe
SELECT * FROM  SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe)
SELECT * FROM SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where BACHNUMB = @sopnumbe) 


use TPEUR

declare @sopnumbe varchar(30)
set @sopnumbe ='ORD107075'
DELETE SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe)
DELETE SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where sopnumbe = @sopnumbe) 
DELETE SOP10100 where sopnumbe = @sopnumbe

