declare @ITEMNMBR char(30)
select @ITEMNMBR = 'A'

print 'Allocated Documents in Sales Order Processing'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SOP10200')
Begin
 print 'Allocated Orders in Sales Order Processing'
select SOPNUMBE,ITEMNMBR,ITEMDESC,ATYALLOC from SOP10200 where ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 and  SOPTYPE = 2
end

if exists (select * from sysobjects where name ='SOP10200')
Begin
 print 'Allocated Invoices in Sales Order Processing'
select SOPNUMBE,ITEMNMBR,ITEMDESC,ATYALLOC from SOP10200 where ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 and  SOPTYPE = 3
end

if exists (select * from sysobjects where name ='SOP10200')
Begin
 print 'Allocated Fulfillment Orders in Sales Order Processing'
select SOPNUMBE,ITEMNMBR,ITEMDESC,ATYALLOC from SOP10200 where ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 and  SOPTYPE = 6
end

Print ''
print 'Allocated Returns in Purchase Order Processing'
print '===============================================================' 
print ''

if exists (select * from sysobjects where name ='POP10500 and POP10310')
Begin
select A.POPRCTNM,A.ITEMNMBR, QTYRESERVED,* from POP10500 A join POP10310 B
on A.POPRCTNM=B.POPRCTNM AND A.RCPTLNNM=B.RCPTLNNM AND A.ITEMNMBR=B.ITEMNMBR 
where A.ITEMNMBR = @ITEMNMBR and A.QTYRESERVED > 0 
end

select A.POPRCTNM,A.ITEMNMBR, QTYRESERVED,* from POP10500 A join POP10310 B 
on B.POPRCTNM=B.POPRCTNM AND A.RCPTLNNM=B.RCPTLNNM AND A.ITEMNMBR=B.ITEMNMBR 
where A.ITEMNMBR = @ITEMNMBR and A.QTYRESERVED > 0 

Print ''
print 'Allocated documents in Inventory'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='IV10001')
Begin
select IVDOCNBR,ITEMNMBR,TRXQTY from IV10001 where ITEMNMBR = @ITEMNMBR and TRXQTY < 0 
select IVDOCNBR,ITEMNMBR,TRXQTY from IV10001 where ITEMNMBR = @ITEMNMBR and TRXQTY > 0 and IVDOCTYP = 3
end

print ''
print 'Allocated Invoices in Invoicing'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='IVC10101')
Begin
select INVCNMBR,ITEMNMBR,QUANTITY from IVC10101 where ITEMNMBR = @ITEMNMBR and DOCTYPE = 1
end

print ''
print 'Allocated Assembly documents in Bill of Materials'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='BM10300')
Begin
select TRX_ID,ITEMNMBR,ATYALLOC from BM10300 where Component_ID <> 0 and ITEMNMBR = @ITEMNMBR and ATYALLOC > 0 
end

Print ''
print 'Allocated Orders in Service Call Management'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SVC00203')
Begin
select CALLNBR,ITEMNMBR,ATYALLOC,LOCNCODE from SVC00203 where ITEMNMBR=@ITEMNMBR and  LINITMTYP='P' AND ATYALLOC <> 0
end
select CALLNBR,ITEMNMBR,ATYALLOC,LOCNCODE from SVC00203 where ITEMNMBR=@ITEMNMBR and  LINITMTYP='P' AND ATYALLOC <> 0

print 'Allocated Service Call Transfers'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SVC00701')
Begin
select ORDDOCID,ITEMNMBR,TRNSFQTY from SVC00701 where ITEMNMBR=@ITEMNMBR and TRNSFQTY <> 0
end

print 'Allocated Service Call Transfers (serial)'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SVC00702')
Begin
select ORDDOCID,ITEMNMBR,SERLTQTY from SVC00702 where ITEMNMBR=@ITEMNMBR and SERLTQTY <> 0
end

print 'Allocated RTV lines'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SVC05601')
Begin
select RTV_Number,ITEMNMBR, QUANTITY, * from SVC05601 where 
ITEMNMBR=@ITEMNMBR and RTV_Status=2 and CUSTOWN=0 and Transfer_Reference=''
end

select RTV_Number,ITEMNMBR, QUANTITY, * from SVC05601 where 
ITEMNMBR=@ITEMNMBR and RTV_Status=2 and CUSTOWN=0 and Transfer_Reference=''

print 'Allocated Documents in Depot Management'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='SVC06100')
Begin
select WORKORDNUM,IBITEMNUM,QUANTITY,LOCNCODE from SVC06100 where IBITEMNUM=@ITEMNMBR AND WORECTYPE = 2 AND QUANTITY <> 0 
End

if exists (select * from sysobjects where name ='SVC06101')
Begin
select WORKORDNUM,ITEMNMBR,ATYALLOC,LOCNCODE from SVC06101 where ITEMNMBR=@ITEMNMBR AND WORECTYPE = 2 and ATYALLOC <> 0    
end

if exists (select * from sysobjects where name ='SVC06120')
Begin
select WORKORDNUM,ITEMNMBR,SERLTQTY from SVC06120 where ITEMNMBR=@ITEMNMBR AND WORECTYPE = 2 AND SERLTQTY <> 0
End

print ''
print 'Allocated Documents in Project Accounting'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='PA10901')
Begin
select PAIV_Document_No,ITEMNMBR,PABase_Qty,LOCNCODE from PA10901 where ITEMNMBR=@ITEMNMBR and 
PABase_Qty <> 0 and PAIV_Transfer_Type = 1
end

print ''
print 'This is the (general) allocated or pending issue quantity in the MOP1400 for this Manufacturing Order'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='MOP1400')
Begin
select MANUFACTUREORDER_I, ITEMNMBR, ATYALLOC from MOP1400 where ATYALLOC > 0 and ITEMNMBR = @ITEMNMBR
end

print 'This is the (bin) allocated quantity in the MOP1900 for this Manufacturing Order'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='MOP1900')
Begin
select MANUFACTUREORDER_I, ITEMNMBR, ATYALLOC, LOCNCODE, BIN from MOP1900 where ATYALLOC > 0 and ITEMNMBR = @ITEMNMBR
end

print 'This is the (lot) allocated or pending issue quantity in MOP1020 for this Manufacturing Order'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='MOP1020')
Begin
select MANUFACTUREORDER_I, ITEMNMBR, SERLTNUM, FROM_SITE_I, DOCNUMBR from MOP1020 where ITEMNMBR =@ITEMNMBR
end

print 'Pending transactions that can hold allocations'
print '==============================================================='
print ''

if exists (select * from sysobjects where name ='MOP1200 and MOP1020 and MOP1025 and MOP1026')
Begin
select * from MOP1020 where DOCNUMBR in (select PICKNUMBER from MOP1200 where POSTED=1)
select * from MOP1025 where MOPDOCNUM in (select PICKNUMBER from MOP1200 where POSTED=1)
select * from MOP1026 where MOPDOCNUM in (select PICKNUMBER from MOP1200 where POSTED=1)
end
