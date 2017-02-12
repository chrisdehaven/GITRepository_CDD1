/*********************************************************************************
** All PO and receipt info for a PO.  Includes all POP tables as well as
**    INV, PM and GL including:							
**	POP10100 - Purchase Order Work						
**	POP10110 - Purchase Order Line						
**	POP10150 - Purchase Order Comment (header)			
**	POP10550 - Purchasing Comment (line)				
**	POP10160 - Purchase Order Tax						
**	POP30100 - Purchase Order History					
**	POP30110 - Purchase Order Line History				
**	POP30160 - Purchase Order Tax History				
**	POP10500 - Purchasing Receipt Line Quantites		
**	POP10600 - Purchasing Shipment Invoice Apply		
**	POP10300 - Purchasing Receipt Work					
**	POP10306 - Purchasing Receipt User-Defined			
**	POP10310 - Purchasing Receipt Line					
**	POP10330 - Purchasing Serial Lot Work				
**	POP10360 - Purchasing Tax						
**	POP10390 - Purchasing Distribution Work			
**	POP10700 - Purchasing Landed Cost				
**	POP30300 - Purchasing Receipt History			
**	POP30310 - Purchasing Receipt Line History		
**	POP30330 - Purchasing Serial Lot History		
**	POP30360 - Purchasing Tax History				
**	POP30390 - Purchasing Distribution History				
**	POP30700 - Purchasing Landed Cost History				
**	IV10200 - Inventory Purchase Receipts Work				
**	IV30300 - Inventory Transaction Amounts History			
**	IV30301 - Inventory Transaction Detail History			
**	IV30302 - Inventory Transaction Bin Quantities History	
**	shouldn't be any records in IV30400 - Item Serial and Lot Number Hist	
**	shouldn't be any records in IV30500 - Inventory Distribution History	
**	PM00400 - PM Keys							
**	PM20000/PM30200 - PM Open / PM History		
**	PM10100/PM30600 - Dist open / Dist hist (VCHRNMBR, CNTRLTYP)		
**	GL10001/GL20000/GL30000 - GL work / GL open / GL history		
**	
**  ^Project Accounting
**  PA10600 - PA PO Work
**  PA10601 - PA PO Line Work
**  PA10602 - PA PO Tax Work
**  PA10701 - PA PO Receipt Work
**  PA10702 - PA PO Receipt Line Work
**  PA10721 - PA PO Receipt Line Quantities Work
**  PA30600 - PA PO History
**  PA30601 - PA PO Line History
**  PA30602 - PA PO Tax History
**  PA31101 - PA PO Receipt History
**  PA31102 - PA PO Receipt Line History
**  
**  ^Encumbrance Management
**  ENC10110 - Encumbrance PO Line
**  ENC10111 - Encumbrance Line Changes
**  ENC10500 - Encumbrance Received Transactions
**  ENC10500 - Purchasing Serial Lot History (Receipt)
**  ENCAA10110 - Encumbrance AA PO Line
**  
**  ^HITB
**  SEE30303 - HITB Transaction History Detail
**  
**  ^Purchase Order Enhancements 
**  CPO10110 - POP Line Control
**  CPO10111 - POP Alloc Line Control
**	CPO10113 - POE Unposted GL Transactions	
**
**   ^Sales Order Processing
**  SOP60100 - SOP_POPLink
**						
** Input PONUMBER					
**									
*********************************************************************************/

----------------------------------------------------------------------------------

declare @PONUMBER char(20)
select @PONUMBER = 'PO01654'
 
----------------------------------------------------------------------------------

set nocount on

if exists (select * from tempdb..sysobjects where name = '##POPRCTNM')
	drop table dbo.##POPRCTNM

create table ##POPRCTNM
(POPRCTNM char(17))

insert into ##POPRCTNM
(POPRCTNM)
select POPRCTNM from POP10310 where PONUMBER = @PONUMBER
	union select POPRCTNM from POP10500 where PONUMBER = @PONUMBER
	union select POPRCTNM from POP30310 where PONUMBER = @PONUMBER

print 'POP PO info'
print '=================================================================================='
print ''

if exists (select * from POP10100 where PONUMBER = @PONUMBER)
Begin
	print 'POP10100 - Purchase Order Work'
	select * from POP10100 where PONUMBER = @PONUMBER
End

if exists (select * from POP10110 where PONUMBER = @PONUMBER)
Begin
	print 'POP10110 - Purchase Order Line'
	select * from POP10110 where PONUMBER = @PONUMBER
End

if exists (select * from POP10150 where POPNUMBE = @PONUMBER)
Begin
	print 'POP10150 - Purchase Order Comment (header)'
	select * from POP10150 where POPNUMBE = @PONUMBER
End

if exists (select * from POP10550 where POPNUMBE = @PONUMBER)
Begin
	print 'POP10550 - Purchasing Comment (line)'
	select * from POP10550 where POPNUMBE = @PONUMBER
End

if exists (select * from POP10160 where PONUMBER = @PONUMBER)
Begin
	print 'POP10160 - Purchase Order Tax'
	select * from POP10160 where PONUMBER = @PONUMBER
End

if exists (select * from POP30100 where PONUMBER = @PONUMBER)
Begin
	print 'POP30100 - Purchase Order History'
	select * from POP30100 where PONUMBER = @PONUMBER
End

if exists (select * from POP30110 where PONUMBER = @PONUMBER)
Begin
	print 'POP30110 - Purchase Order Line History'
	select * from POP30110 where PONUMBER = @PONUMBER
End

if exists (select * from POP30160 where PONUMBER = @PONUMBER)
Begin
	print 'POP30160 - Purchase Order Tax History'
	select * from POP30160 where PONUMBER = @PONUMBER
End

print 'POP All apply info for PO'
print '=================================================================================='
print ''

if exists (select * from POP10500 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10500 - Purchasing Receipt Line Quantites'
	select * from POP10500 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10600 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10600 - Purchasing Shipment Invoice Apply'
	select * from POP10600 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
end

print 'POP All work receipt info for PO'
print '=================================================================================='
print ''

if exists (select * from POP10300 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10300 - Purchasing Receipt Work'
	select * from POP10300 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10306 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10306 - Purchasing Receipt User-Defined'
	select * from POP10306 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10310 where PONUMBER = @PONUMBER)
Begin
	print 'POP10310 - Purchasing Receipt Line'
	select * from POP10310 where PONUMBER = @PONUMBER
End

if exists (select * from POP10330 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10330 - Purchasing Serial Lot Work'
	select * from POP10330 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10360 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10360 - Purchasing Tax'
	select * from POP10360 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10390 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10390 - Purchasing Distribution Work'
	select * from POP10390 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP10700 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP10700 - Purchasing Landed Cost'
	select * from POP10700 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

print 'POP All history receipt info for PO'
print '=================================================================================='
print ''

if exists (select * from POP30300 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30300 - Purchasing Receipt History'
	select * from POP30300 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30310 - Purchasing Receipt Line History'
	select * from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP30330 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30330 - Purchasing Serial Lot History'
	select * from POP30330 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP30360 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30360 - Purchasing Tax History'
	select * from POP30360 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP30390 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30390 - Purchasing Distribution History'
	select * from POP30390 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from POP30700 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'POP30700 - Purchasing Landed Cost History'
	select * from POP30700 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

print 'Inventory'
print '=================================================================================='
print ''

if exists (select RCPTNMBR, * from IV10200 where RCPTNMBR in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'IV10200 - Inventory Purchase Receipts Work'
	select RCPTNMBR, * from IV10200 where RCPTNMBR in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from IV30300 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'IV30300 - Inventory Transaction Amounts History'
	select * from IV30300 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from IV30301 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'IV30301 - Inventory Transaction Detail History'
	select * from IV30301 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM)
End

if exists (select * from IV30302 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'IV30302 - Inventory Transaction Bin Quantities History'
	select * from IV30302 where DOCTYPE = 4 and DOCNUMBR in (select POPRCTNM from ##POPRCTNM)
End

-- shouldn't be any records in IV30400 (Item Serial/Lot Hist)

-- shouldn't be any records in IV30500 (INV Dist History)

print 'Payables'
print '=================================================================================='
print ''

if exists (select b.POPRCTNM, a.* 
		from PM00400 a 
		join POP30300 b on a.CNTRLNUM = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'PM00400 - PM Keys'
	select b.POPRCTNM, a.* 
		from PM00400 a 
		join POP30300 b on a.CNTRLNUM = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 2 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM20000 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
	   union select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 3 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM30200 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'PM20000/PM30200 - PM Open / PM History'
	select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 2 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM20000 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
	   union select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 3 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM30200 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

if exists (select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 2 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM10100 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
	   union select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 3 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM30600 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM))
Begin
	print 'PM10100/PM30600 - PM Dist open / PM Dist History'
	select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 2 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM10100 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
	   union select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 3 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM30600 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM in (select POPRCTNM from ##POPRCTNM)
End

print 'GL'
print '=================================================================================='
print ''

if exists (select ORDOCNUM, JRNENTRY, 1 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL10001 where ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 2 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL20000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 3 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL30000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY)
Begin
	print 'GL10001/GL20000/GL30000 - GL work / GL open / GL history'
	select ORDOCNUM, JRNENTRY, 1 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL10001 where ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 2 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL20000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 3 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL30000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)) group by ORDOCNUM, JRNENTRY
End


/* check if PA installed, if yes, check those tables */

if exists (select * from sysobjects where name ='PA10600')
	begin
		print 'Project Accounting'
		print '=================================================================================='
		print ''

		if exists( select * from PA10600 where PApurordnum = @PONUMBER )
			begin
				print 'PA10600 - PA PO Work'
				select * from PA10600 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA10601 where PApurordnum = @PONUMBER )
			begin
				print 'PA10601 - PA PO Line Work'
				select * from PA10601 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA10602 where PApurordnum = @PONUMBER )
			begin
				print 'PA10602 - PA PO Tax Work'
				select * from PA10602 where PApurordnum = @PONUMBER
			end

		if exists(select * from PA10701 where PAVIDN in (select PAVIDN from PA10702 where PApurordnum = @PONUMBER))
			begin
				print 'PA10701 - PA PO Receipt Work'
				select * from PA10701 where PAVIDN in (select PAVIDN from PA10702 where PApurordnum = @PONUMBER)
			end
			
		if exists( select * from PA10702 where PApurordnum = @PONUMBER )
			begin
				print 'PA10702 - PA PO Receipt Line Work'
				select * from PA10702 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA10721 where PApurordnum = @PONUMBER )
			begin
				print 'PA10721 - PA PO Receipt Line Quantities Work'
				select * from PA10721 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA30600 where PApurordnum = @PONUMBER )
			begin
				print 'PA30600 - PA PO History'
				select * from PA30600 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA30601 where PApurordnum = @PONUMBER )
			begin
				print 'PA30601 - PA PO Line History'
				select * from PA30601 where PApurordnum = @PONUMBER
			end
			
		if exists( select * from PA30602 where PApurordnum = @PONUMBER )
			begin
				print 'PA30602 - PA PO Tax History'
				select * from PA30602 where PApurordnum = @PONUMBER
			end

		if exists(select * from PA31101 where PAVIDN in (select PAVIDN from PA31102 where PApurordnum = @PONUMBER))
			begin
				print 'PA31101 - PA PO Receipt History'
				select * from PA31101 where PAVIDN in (select PAVIDN from PA31102 where PApurordnum = @PONUMBER)
			end
			
		if exists( select * from PA31102 where PApurordnum = @PONUMBER )
			begin
				print 'PA31102 - PA PO Receipt Line History'
				select * from PA31102 where PApurordnum = @PONUMBER
			end
	end
	
/* Check if Encumbrance tables exist */
if exists (select * from sysobjects where name ='ENC10500')
	begin
		print 'Encumbrance'
		print '=================================================================================='
		print ''
			
		if exists( select * from ENC10110 where PONUMBER = @PONUMBER )
			begin
				print 'ENC10110 - Encumbrance PO Line'
				select * from ENC10110 where PONUMBER = @PONUMBER
			end
		if exists( select * from ENC10111 where PONUMBER = @PONUMBER )
			begin
				print 'ENC10111 - Encumbrance Line Changes'
				select * from ENC10111 where PONUMBER = @PONUMBER
			end
		if exists( select * from ENC10500 where PONUMBER = @PONUMBER )
			begin
				print 'ENC10500 - Encumbrance Received Transactions (POs)'
				select * from ENC10500 where PONUMBER = @PONUMBER
			end
			
		if exists (select * from ENC10500 where POPRCTNM in (select POPRCTNM from ##POPRCTNM))
			begin
				print 'ENC10500 - Encumbrance Received Transactions (Receipt)'
				select * from ENC10500 where POPRCTNM in (select POPRCTNM from ##POPRCTNM)
			end
			
		if exists( select * from ENCAA10110 where PONUMBER = @PONUMBER )
			begin
				print 'ENCAA10110 - Encumbrance AA PO Line'
				select * from ENCAA10110 where PONUMBER = @PONUMBER
			end

	end	
/* Check if HITB tables exist */
if exists (select * from sysobjects where name ='SEE30303')
	begin
		print 'HITB'
		print '=================================================================================='
		print ''
		
		if exists (select * from SEE30303 where PONUMBER = @PONUMBER )
			begin
				print 'SEE30303 - HITB Transaction History Detail'
				select * from SEE30303 where PONUMBER = @PONUMBER
			end
	end
/* Check if POE tables exist */	
if exists (select * from sysobjects where name ='CPO10110')
	begin
		print 'Purchase Order Enhancements'
		print '=================================================================================='
		print ''
		
		if exists( select * from CPO10110 where PONUMBER = @PONUMBER )
			begin
				print 'CPO10110 - POP Line Control'
				select * from CPO10110 where PONUMBER = @PONUMBER
			end	
	    
	    if exists( select * from CPO10111 where PONUMBER = @PONUMBER )
			begin
				print 'CPO10111 - POP Alloc Line Control'
				select * from CPO10111 where PONUMBER = @PONUMBER	
			end
        
        if exists( select * from CPO10113 where DTAControlNum = @PONUMBER )
			begin
				print 'CPO - POE Unposted GL Transactions'
				select * from CPO10113 where DTAControlNum = @PONUMBER
			end	
	end		


/* Check if SOP-POP link exists */
if exists (select * from sysobjects where name ='SOP60100')
	begin
		print 'SOP to POP link'
		print '=================================================================================='
		print ''
			
		if exists( select * from SOP60100 where PONUMBER = @PONUMBER )
			begin
				print 'SOP60100 - SOP to POP link'
				select * from SOP60100 where PONUMBER = @PONUMBER
				
				end
				
	end

set nocount off