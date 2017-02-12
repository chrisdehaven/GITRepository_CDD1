use TPSPT

declare @username varchar(30)
set @username ='mbrown'

SELECT * from SY00500 where BACHNUMB = @username
SELECT BACHNUMB,* from SOP10100 where BACHNUMB = @username 
SELECT * FROM  SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where BACHNUMB = @username)
SELECT * FROM SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where BACHNUMB = @username) 

DELETE SY00500 where BACHNUMB = @username
DELETE SOP10200 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where BACHNUMB = @username)
DELETE SOP10102 where SOPNUMBE in (SELECT SOPNUMBE from SOP10100 where BACHNUMB = @username) 
DELETE SOP10100 where BACHNUMB = @username

