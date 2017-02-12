-- run the unlock batches routine. Then look for all batches using the checkbook id that is the problem for other batches that are marked to post and clear the status to 0

select * from sy00500 where bachnumb like '10132015%'

select * from sy00500 where chekbkid = 'HSBC-MONT-CDN  '

UPDATE SY00500 SET MKDTOPST=0, BCHSTTUS=0 where BACHNUMB='ONDUCORR'