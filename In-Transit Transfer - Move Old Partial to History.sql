Status Codes for SVC00700 table

0 = open
1 = picked
3 = partial shipped
4 = shipped
5 = partial received
6 = received
99 = in use

select * from SVC00700 where ORDDOCID in('00000358')


use gican
go
UPDATE SVC00700 SET STATUS = 4 WHERE ORDDOCID in('00000358')

exec SVC_Transfer_TransferToHistory 'TransferNumber' 