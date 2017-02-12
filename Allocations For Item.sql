DECLARE @ITEMNMBR char(20)

SET @ITEMNMBR = 'T106200'

PRINT 'This is the allocated quantity in the SOP10200 for Orders'

select SOPNUMBE,ITEMNMBR,ITEMDESC,ATYALLOC from SOP10200 where ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 and SOPTYPE = 2

PRINT 'This is the allocated quantity in the SOP10200 for Invoices'

select SOPNUMBE,ITEMNMBR,ITEMDESC,ATYALLOC from SOP10200 where ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 and SOPTYPE = 3

PRINT 'This is the allocated quantity in the IV10001 for a decrease Adjustment'

select IVDOCNBR,ITEMNMBR,TRXQTY from IV10001 where ITEMNMBR = @ITEMNMBR and TRXQTY < 0

PRINT 'This is the allocated quantity in the IV10001 for Transfers'

select IVDOCNBR,ITEMNMBR,TRXQTY from IV10001 where ITEMNMBR = @ITEMNMBR and TRXQTY > 0 and IVDOCTYP = 3

PRINT 'This is the allocated quantity in the IVC10101 for saved Invoices'

select INVCNMBR,ITEMNMBR,QUANTITY from IVC10101 where ITEMNMBR = @ITEMNMBR and DOCTYPE = 1

PRINT 'This is the allocated quantity in the BM10300 '

select TRX_ID,ITEMNMBR,ATYALLOC from BM10300 where Component_ID <> 0 and ITEMNMBR = @ITEMNMBR and ATYALLOC > 0

PRINT 'This is the allocated quantity in the MOP1400 for this Manufacturing Order'

select MANUFACTUREORDER_I, ITEMNMBR, ATYALLOC from MOP1400 where ATYALLOC > 0 and ITEMNMBR = @ITEMNMBR

/* FIELD SERVICE TABLES */
PRINT 'Allocated Orders in Service Call Management'

select CALLNBR,ITEMNMBR,ATYALLOC,LOCNCODE from SVC00203 where ITEMNMBR=@ITEMNMBR and ATYALLOC <> 0

SELECT ITEMNMBR,QTYONHND,ATYALLOC FROM SVC00502 WHERE ITEMNMBR = @ITEMNMBR

PRINT 'Allocated Service Call Transfers'

select ORDDOCID,ITEMNMBR,TRNSFQTY from SVC00701 where ITEMNMBR=@ITEMNMBR and TRNSFQTY <> 0

PRINT 'Allocated Documents in Depot Management'

select WORKORDNUM,ITEMNMBR,UOFM,QTYORDER,ATYALLOC from svc06101 WHERE ITEMNMBR = @ITEMNMBR