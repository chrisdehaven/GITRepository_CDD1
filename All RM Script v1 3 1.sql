/*
All RM Script

Definition:  Queries RM Transaction tables, Apply tables, SOP, BR, MC, GL to find a given document/document type.

Usage Notes:

Enter your Document Number into the @docnum variable.

For the @rmdtypal variable:
	- For a Debit-type document, enter the following:
	  Sales/Invoice = '1'
	  Scheduled Payment = '2'
	  Debit Memo = '3' 
	  Finance Charges = '4'
	  Service Repairs = '5'
	  Warranties = '6'
	- For a Credit-type document, enter the following:
	  Credit Memos = '7'
	  Returns = '8'
	  Payments/Cash Receipts = '9'

Created by:  Jonathan Boice (v-jonboi@microsoft.com)
Version: 1.3

ADDED:
SOP checking (SOP30200) - Added checking to see if document originated in SOP - v1.1 - 02/17/14
BR Results - Added Cash Receipts check, CM Transactions check - v1.1 - 02/17/14, 
				corrected Cash Receipt search from checking RCPTNMBR to checking SRCDOCNUM - v1.2 02/27/14
GL Results - Added checking for GL10000, GL20000, GL30000 - v1.1 - 02/17/14
MC Results - Added checking for MC020102, MC020104 - v1.2 02/27/14
Added transaction checking for @rmdtypal values to help prevent duplicate @docnum values from being pulled if exists under different Customer - v1.3 - 03/05/14
*/

declare @docnum varchar(30)
declare @rmdtypal varchar(1)

set @docnum ='PYMNT00053370'
set @rmdtypal = '9'

print '*****SOP CHECK*****'
print ''
if exists (select * from SOP30200 where SOPNUMBE = @docnum) 
BEGIN
	print 'SOP Document detected.  Please request then run All SOP Scripting'
	print ''
END
else
	print 'No SOP connection found'
	print ''
	
print '*****TRANSACTION RECORDS*****'
print ''

if exists (select * from RM00401 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal)
BEGIN
	print 'RM00401 - RM Keys'
	select * from RM00401 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM10101 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal)
BEGIN
	print 'RM10101 - RM Distribution Work/Open'
	select * from RM10101 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM10201 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal)
BEGIN
	print 'RM10201 - RM Cash Receipts'
	select * from RM10201 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM10301 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal)
BEGIN
print 'RM10301 - RM Sales Work'
select * from RM10301 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM20101 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal)
BEGIN
print 'RM20101 - RM Open'
select * from RM20101 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM30101 where DOCNUMBR = @docnum)
BEGIN
print 'RM30101 - RM History'
select * from RM30101 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

if exists (select * from RM30301 where DOCNUMBR = @docnum)
BEGIN
print 'RM30301 - RM Distribution History'
select * from RM30301 where DOCNUMBR = @docnum and RMDTYPAL = @rmdtypal
END

print '*****APPLY RECORDS*****'
print ''

if @rmdtypal > '6'
BEGIN
	if exists (select * from RM20201 where APFRDCNM = @docnum and APFRDCTY = @rmdtypal)
	BEGIN
		print 'RM20201 - RM Apply Work/Open'
		select * from RM20201 where APFRDCNM = @docnum and APFRDCTY = @rmdtypal
	END
	if exists (select * from RM30201 where APFRDCNM = @docnum and APFRDCTY = @rmdtypal)
	BEGIN
		print 'RM30201 - RM Apply History'
		select * from RM30201 where APFRDCNM = @docnum and APFRDCTY = @rmdtypal
	END
END
else
	if exists (select * from RM20201 where APTODCNM = @docnum and APTODCTY = @rmdtypal)
	BEGIN
		print 'RM20201 - RM Apply Work/Open'
		select * from RM20201 where APTODCNM = @docnum and APTODCTY = @rmdtypal
	END
	if exists (select * from RM30201 where APTODCNM = @docnum and APTODCTY = @rmdtypal)
	BEGIN
		print 'RM30201 - RM Apply History'
		select * from RM30201 where APTODCNM = @docnum and APTODCTY = @rmdtypal
	END

print '*****MULTICURRENCY MANAGEMENT*****'
print ''

if exists (select * from MC020102 where DOCNUMBR = @docnum)
BEGIN
print 'MC020102 - Multicurrency Receivables Transactions'
select * from MC020102 where DOCNUMBR = @docnum
END

if exists (select * from MC020104 where DOCNUMBR = @docnum)
BEGIN
print 'MC020104 - Multicurrency RM Revaluation Activity'
select * from MC020104 where DOCNUMBR = @docnum
END

print '*****BANK RECONCILIATION*****'
print ''

if @RMDTYPAL = '9'
BEGIN
	if exists (select * from CM20200 where SRCDOCNUM = (select depositnumber from CM20300 where SRCDOCNUM = @docnum))
	BEGIN	
		print 'CM20200 - CM Transaction'
		select * from CM20200 where SRCDOCNUM = (select depositnumber from CM20300 where SRCDOCNUM = @docnum)
	END
	if exists (select * from CM20300 where RCPTNMBR = @docnum)
	BEGIN
		print 'CM20300 - CM Receipt'
		select * from CM20300 where RCPTNMBR = @docnum
	END
END

print '*****GENERAL LEDGER*****'
print ''

if exists (select * from GL10000 where DTAControlNum  = @docnum and DTATRXType = @rmdtypal)
BEGIN
print 'GL10000 - GL Work'
select * from GL10000 where DTAControlNum = @docnum and DTATRXType = @rmdtypal
END

if exists (select * from GL20000 where ORCTRNUM = @docnum and ORTRXTYP = @rmdtypal)
BEGIN
print 'GL20000 - GL Open'
select * from GL20000 where ORCTRNUM = @docnum and ORTRXTYP = @rmdtypal
END

if exists (select * from GL30000 where ORCTRNUM = @docnum and ORTRXTYP = @rmdtypal)
BEGIN
print 'GL30000 - GL History'
select * from GL30000 where ORCTRNUM = @docnum and ORTRXTYP = @rmdtypal
END