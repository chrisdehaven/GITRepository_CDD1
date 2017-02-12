/*********************************************************************************
** All SOP info for specific sales document.  Includes all SOP tables as well	**
**    as INV, RM and GL	including:
**	SOP10100 - Sales Transaction Work							**
**	SOP10101 - Sales Commission Work and History				**
**	SOP10102 - Sales Distribution Work and History				**
**	SOP10103 - Sales Payment Work and History					**
** 	SOP10104 - Sales Process Holds Work and History				**
** 	SOP10105 - Sales Tax Work and Hisory						**
**	SOP00106 - Sales User-Defined Work History					**
**	SOP00107 - Sales Tracking Numbers Work History				**
**	SOP10200 - Sales Transaction Amounts Work					**
**	SOP10201 - Sales Serial/Lot Work and History				**
**	SOP10202 - Sales Line Comment Work and History				**
**	SOP10203 - Sales order Bin Quantities Work and History		**
**	SOP10204 - Extended Pricing Promotion Work					**
**	SOP30200 - Sales Transaction History						**
**	SOP30201 - Sales Deposit History							**
**	TX30000 - Tax History										**
**	SOP60100 - SOP_POP Link										**
**	IV10201 - Inventory Purchase Receipts Detail				**
**	IV30300 - Inventory Transaction Amounts History				**
**	IV30301 - Inventory Transaction Detail History				**
**	IV30302 - Inventory Transaction Bin Quantities History		**
**	shouldn't be any records in IV30400							**
**	IV30500 - Inventory Distribution History					**
**	SEE30303 - Inventory Transaction History Detail 			**
**	PP000100 - Deferral Header Work								**
**	PP000101 - Deferral Line Work								**
**	PP100100 - Deferral Header History							**
**	PP100101 - Deferral Line History							**
**	RM00401 - RM Key File										**
**	RM20101/RM30101 - RM Open / RM History						**
**	RM10101/RM30301 - RM Dist Open / RM Dist History			**
**	RM20201/RM30201 - RM Apply Open/ RM Apply History			**
**	GL10001/GL20000/GL30000 - GL work / GL open / GL history	**
**	CM20100 - CM Journal										**
**	CM20300 - CM Receipt										**
**	SVC00600 - Contract Header									**

**																**
** Input SOPTYPE and SOPNUMBE									**
**																**
** 1 Quote														**
** 2 Order														**
** 3 Invoice													**
** 4 Return														**
** 5 Back Order													**
** 6 Fulfillment Order											**
** Note: can tune script for in (5,6) and (1,8) statements		**
*********************************************************************************/

declare @SOPTYPE smallint
declare @SOPNUMBE char(21)
select @SOPTYPE = '2'
select @SOPNUMBE = 'ORD648935'

print 'Sales'
print '=================================================================================='
print ''

if exists (select * from SOP10100 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10100 - Sales Work'
	select * from SOP10100 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10101 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin	
	print 'SOP10101 - Sales Commissions Work and History'
	select * from SOP10101 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10102 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin	
	print 'SOP10102 - Sales Distribution Work and History'
	select * from SOP10102 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10103 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10103 - Sales Payment Work and History'
	select * from SOP10103 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10104 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin	
	print 'SOP10104 - Sales Process Holds Work and History'
	select * from SOP10104 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10105 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10105 - Sales Taxes Work and History'
	select * from SOP10105 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10106 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10106 - Sales User-Defined Work and History'
	select * from SOP10106 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10107 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10107 - Sales Tracking Numbers Work and History'
	select * from SOP10107 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10200 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10200 - Sales Transaction Amounts Work'
	select * from SOP10200 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10201 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10201 - Sales Serial/Lot Work and History'
	select * from SOP10201 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10202 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10202 - Sales Line Comment Work and History'
	select * from SOP10202 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10203 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10203 - Sales Order Bin Quantities Work and History'
	select * from SOP10203 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP10204 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP10204 - Extended Pricing Promotion Work'
	select * from SOP10204 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP30200 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP30200 - Sales Transaction History'
	select * from SOP30200 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP30201 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP30201 - Sales Deposit History'
	select * from SOP30201 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

if exists (select * from SOP30300 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP30300 - Sales Transaction Amounts History'
	select * from SOP30300 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End
if exists (select * from TX30000 where DOCNUMBR = @SOPNUMBE and SERIES = 1)
Begin
	print 'TX30000 - Tax History'
	select * from TX30000 where DOCNUMBR = @SOPNUMBE and SERIES = 1
End

if exists (select * from SOP60100 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE)
Begin
	print 'SOP60100 - SOP_POPLink'
	select * from SOP60100 with (nolock) where SOPTYPE = @SOPTYPE and SOPNUMBE = @SOPNUMBE
End

print 'Inventory'
print '=================================================================================='
print ''

if exists (select * from IV10201 where ORIGINDOCID = @SOPNUMBE)
Begin
	print 'IV10201 - Inventory Purchase Receipts Detail'
	select * from IV10201 where ORIGINDOCID = @SOPNUMBE
End

if exists (select * from IV30300 where DOCNUMBR = @SOPNUMBE and DOCTYPE in (5,6))
Begin
	print 'IV30300 - Inventory Transaction Amounts History'
	if @SOPTYPE = 3 (select * from IV30300 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 6)
	if @SOPTYPE = 4 (select * from IV30300 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 5)
End

if exists (select * from IV30301 where DOCNUMBR = @SOPNUMBE and DOCTYPE in (5,6))
Begin
	print 'IV30301 - Inventory Transaction Detail History'
	if @SOPTYPE = 3 (select * from IV30301 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 6)
	if @SOPTYPE = 4 (select * from IV30301 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 5)
End

if exists (select * from IV30302 where DOCNUMBR = @SOPNUMBE and DOCTYPE in (5,6))
Begin
	print 'IV30302 - Inventory Transaction Bin Quantities History'
	if @SOPTYPE = 3 (select * from IV30302 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 6)
	if @SOPTYPE = 4 (select * from IV30302 where DOCNUMBR = @SOPNUMBE and DOCTYPE = 5)
End

-- shouldn't be any records in IV30400

if exists (select * from IV30500 where DOCNUMBR = @SOPNUMBE and IVDOCTYP in (5,6))
Begin
	print 'IV30500 - Inventory Distribution History'
	if @SOPTYPE = 3 (select * from IV30500 where DOCNUMBR = @SOPNUMBE and IVDOCTYP = 6)
	if @SOPTYPE = 4 (select * from IV30500 where DOCNUMBR = @SOPNUMBE and IVDOCTYP = 5)
End

/*check if HITB table exists*/
if exists (select * from sysobjects where name = 'SEE30303')
Begin

if exists (select * from SEE30303 where DOCNUMBR = @SOPNUMBE and DOCTYPE in (5,6))

	print 'SEE30303 - Inventory Transaction History Detail table (HITB)'
	select * from SEE30303 where DOCNUMBR = @SOPNUMBE
End


/* Check if RED tables exist */
if exists (select * from sysobjects where name in ('PP000100', 'PP000101', 'PP100100', 'PP100101'))
Begin

       print 'Revenue/Expense Deferrals'
       print '=================================================================================='
       print ''

       if exists (select PP_Document_Number, 1 as Status, TRXAMNT
       from PP000100 where PP_Document_Number = @SOPNUMBE
       union select PP_Document_Number, 3 as Status, TRXAMNT 
       from PP100100 where PP_Document_Number = @SOPNUMBE)

              print 'PP000100/PP100100 - Deferral Header Work/Deferral Header History'
              select PP_Document_Number, 1 as Status, TRXAMNT 
              from PP000100 where PP_Document_Number = @SOPNUMBE
              union 
              select PP_Document_Number, 3 as Status, TRXAMNT 
              from PP100100 where PP_Document_Number = @SOPNUMBE

       if exists (select PP_Document_Number, 1 as Status, GLPOSTDT
       from PP000101 where PP_Document_Number = @SOPNUMBE
       union select PP_Document_Number, 3 as Status, GLPOSTDT
       from PP100101 where PP_Document_Number = @SOPNUMBE)

              print 'PP000101/PP100101 - Deferral Line Work/Deferral Line History'
              select PP_Document_Number, 1 as Status, GLPOSTDT
              from PP000101 where PP_Document_Number = @SOPNUMBE
              union 
              select PP_Document_Number, 3 as Status, GLPOSTDT
              from PP100101 where PP_Document_Number = @SOPNUMBE

End


print 'Receivables'
print '=================================================================================='
print ''

if exists (select * from RM00401 where DOCNUMBR = @SOPNUMBE and RMDTYPAL in (1,8))
Begin
	print 'RM00401 - RM Key File'
	if @SOPTYPE = 3 (select * from RM00401 where DOCNUMBR = @SOPNUMBE and RMDTYPAL = 1)
	if @SOPTYPE = 4 (select * from RM00401 where DOCNUMBR = @SOPNUMBE and RMDTYPAL = 8)
End

if exists (select DOCNUMBR, RMDTYPAL, 2 as Status, CURTRXAM, CUSTNMBR, TRXSORCE, DOCDATE, ORTRXAMT
			from RM20101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
		union select DOCNUMBR, RMDTYPAL, 3 as Status, CUSTNMBR, TRXSORCE, DOCDATE, ORTRXAMT, CURTRXAM
			from RM30101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE)
Begin
	print 'RM20101/RM30101 - RM Open / RM History'
	select DOCNUMBR, RMDTYPAL, 2 as Status, CUSTNMBR, TRXSORCE, DOCDATE, ORTRXAMT, CURTRXAM
			from RM20101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
		union select DOCNUMBR, RMDTYPAL, 3 as Status, CUSTNMBR, TRXSORCE, DOCDATE, ORTRXAMT, CURTRXAM
			from RM30101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
End

if exists (select DOCNUMBR, RMDTYPAL, 2 as Status, CUSTNMBR, TRXSORCE 
			from RM10101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
		union select DOCNUMBR, RMDTYPAL, 3 as Status, CUSTNMBR, TRXSORCE
			from RM30301 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE)
Begin
	print 'RM10101/RM30301 - RM Dist Open / RM Dist History'
	select DOCNUMBR, RMDTYPAL, 2 as Status, CUSTNMBR, TRXSORCE 
			from RM10101 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
		union select DOCNUMBR, RMDTYPAL, 3 as Status, CUSTNMBR, TRXSORCE
			from RM30301 where RMDTYPAL in (1,8) and DOCNUMBR = @SOPNUMBE
End

if exists (select * from RM20201 where APTODCNM = @SOPNUMBE and APTODCTY in (1,8)
union
select * from RM30201 where APTODCNM = @SOPNUMBE and APTODCTY in (1,8))

Begin
	Print 'RM20201/RM30201 - RM Apply Open/ RM Apply History'
	select * from RM20201 where APTODCNM = @SOPNUMBE and APTODCTY in (1,8)
	union
	select * from RM30201 where APTODCNM = @SOPNUMBE and APTODCTY in (1,8)	
End		

print 'GL'
print '=================================================================================='
print ''

if exists (select ORDOCNUM from GL10001 where ORDOCNUM = @SOPNUMBE 
		union select ORDOCNUM from GL20000 where SERIES = 3 and ORDOCNUM = @SOPNUMBE
		union select ORDOCNUM from GL30000 where SERIES = 3 and ORDOCNUM = @SOPNUMBE)
Begin
	print 'GL10001/GL20000/GL30000 - GL work / GL open / GL history'
	select ORDOCNUM, JRNENTRY, 1 as Status from GL10001 where ORDOCNUM = @SOPNUMBE 
		union select ORDOCNUM, JRNENTRY, 2 as Status from GL20000 where SERIES = 3 and ORDOCNUM = @SOPNUMBE
		union select ORDOCNUM, JRNENTRY, 3 as Status from GL30000 where SERIES = 3 and ORDOCNUM = @SOPNUMBE
End


print 'Bank Rec'
print '=================================================================================='
print ''

if exists (select * from CM20100 where AUDITTRAIL in (select TRXSORCE from SOP30200 where SOPNUMBE = @SOPNUMBE))
Begin
	print 'CM20100 - CM Journal'
	select * from CM20100 where AUDITTRAIL in (select TRXSORCE from SOP30200 where SOPNUMBE = @SOPNUMBE)
End

if exists (select * from CM20300 where SRCDOCNUM = @SOPNUMBE)
Begin
	print 'CM20300 - CM Receipt'
	select * from CM20300 where SRCDOCNUM = @SOPNUMBE
End


/*check if HITB table exists*/
if exists (select * from sysobjects where name = 'SVC00600')
Begin

print 'Contract Administration'
print '=================================================================================='
print ''

if exists (select * from SVC00600 where Source_Contract_Number = @SOPNUMBE)

	print 'SVC00600 - Contract Header'
	select * from SVC00600 where Source_Contract_Number = @SOPNUMBE
End

