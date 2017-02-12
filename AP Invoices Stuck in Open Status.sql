https://community.dynamics.com/gp/f/32/t/97437.aspx



I would not recommend the SQL route unless you know exactly what the problem is first. You should try first checking all the batch posting windows to make sure the transaction is not hung up waiting to be posted first. Next, I would try to void the payment, then re-enter it. When you cut checks in GP, the payment is automatically applied to the voucher, so you would not see this in the apply payables docs screen if it is a check run payment.

Have you also run an inquiry on the vendor documents to see if both the voucher and payment are listed, and if they are applied to each other?

If you have also made any changes to SQL, you should run the Check Links routine on PM tables. If the problem is an orphaned SQL record, the resulting report from this routine will usually either fix the problem, or it will tell you what the problem is.

If you do not have the system set up to record values at anything more than 2 decimal places, I would not run the script suggested above.

Hi Guys,

Thanks for raising this issue with me. It�s possible that the records are not moving to history as they still have a very small unapplied amount on them in SQL. As an example instead of the current transaction amount being 0.00000 it�s 0.00012, this would prevent the record moving to history.

To check this can you please run this script to check the current transaction amount for the problem transactions:

select CURTRXAM,* from PM20000 where VCHRNMBR ='XXXX' and VENDORID ='YYYY'

If the current transaction amount for any of these records is not 0.00000 please run this script to reset the amount to zero after first making a backup:

update PM20000 set CURTRXAM = '0.00000' where VCHRNMBR ='XXXX' and VENDORID ='YYYY'

After this please run checklinks on the payables transaction logical files and the records should now move to history as expected. If the current transaction amount for the problem invoices is already at zero we can use a SQL script to move them to the  history tables, I'll copy this in below this reply




To use the script please insert the voucher number and document type in the indicated fields then run the script against the company database. This will then remove the records from the PM open tables and write them to the PM history tables. I suggest that you run this script in test first and verify the results before running in the live company.

Please let me know if you would like any additional information on this issue.

Regards

Rob

-- Move PM debit docs from open to history

DESCRIPTION:

Moves a specific document and associated tax and apply records from the PM open tables back to history status.

INSTRUCTIONS:

1. Make a backup of the company database.

2. Enter the voucher number in the indicated field.

3. Enter the document type of the transaction in the indicated field.

  Valid document types are:

1 = Invoice

2 = Finance Charge

3 = Miscellaneous Charge

4 = Return

5 = Credit Memo

6 = Payment

4. Execute the script.

5. Verify that the document moved correctly to history status.

--

-- select * from ##PMMoveDebitOpenToHist

-- drop table ##PMMoveDebitOpenToHist

select CNTRLNUM as VCHRNMBR, DOCTYPE, DOCNUMBR into ##PMMoveDebitOpenToHist

from PM00400 where CNTRLNUM = 'XXXX' and DOCTYPE = 'X'

-- Insert open records to hist

insert into PM30200

(VCHRNMBR,VENDORID,DOCTYPE,DOCDATE,DOCNUMBR,DOCAMNT,                                                                                                                                                                                                            

CURTRXAM,DISTKNAM,DISCAMNT,DSCDLRAM,BACHNUMB,TRXSORCE,                                                                                                                                                                                                        

BCHSOURC,DISCDATE,DUEDATE,PORDNMBR,TEN99AMNT,WROFAMNT,                                                                                                                                                                                                        

DISAMTAV,TRXDSCRN,UN1099AM,BKTPURAM,BKTFRTAM,BKTMSCAM,                                                                                                                                                                                                        

VOIDED,HOLD,CHEKBKID,DINVPDOF,PPSAMDED,PPSTAXRT,                                                                                                                                                                                                              

PGRAMSBJ,GSTDSAMT,POSTEDDT,PTDUSRID,MODIFDT,MDFUSRID,                                                                                                                                                                                                          

PYENTTYP,CARDNAME,PRCHAMNT,TRDISAMT,MSCCHAMT,FRTAMNT,                                                                                                                                                                                                          

TAXAMNT,TTLPYMTS,CURNCYID,PYMTRMID,SHIPMTHD,TAXSCHID,                                                                                                                                                                                                          

PCHSCHID,FRTSCHID,MSCSCHID,PSTGDATE,DISAVTKN,CNTRLTYP,                                                                                                                                                                                                        

NOTEINDX,PRCTDISC,RETNAGAM,VOIDPDATE,ICTRX,Tax_Date,                                                                                                                                                                                                          

PRCHDATE,CORRCTN,SIMPLIFD,APLYWITH,Electronic,ECTRX,                                                                                                                                                                                                          

DocPrinted,TaxInvReqd,VNDCHKNM,BackoutTradeDisc,CBVAT)

select

a.VCHRNMBR, a.VENDORID, a.DOCTYPE, a.DOCDATE, a.DOCNUMBR, a.DOCAMNT,                                                                                                                                                                                          

a.CURTRXAM, a.DISTKNAM, a.DISCAMNT, a.DSCDLRAM, a.BACHNUMB, a.TRXSORCE,                                                                                                                                                                                      

a.BCHSOURC, a.DISCDATE, a.DUEDATE, a.PORDNMBR, a.TEN99AMNT, a.WROFAMNT,                                                                                                                                                                                      

a.DISAMTAV, a.TRXDSCRN, a.UN1099AM, a.BKTPURAM, a.BKTFRTAM, a.BKTMSCAM,                                                                                                                                                                                      

a.VOIDED, a.HOLD, a.CHEKBKID, a.DINVPDOF, a.PPSAMDED, a.PPSTAXRT,                                                                                                                                                                                            

a.PGRAMSBJ, a.GSTDSAMT, a.POSTEDDT, a.PTDUSRID, a.MODIFDT, a.MDFUSRID,                                                                                                                                                                                        

a.PYENTTYP, a.CARDNAME, a.PRCHAMNT, a.TRDISAMT, a.MSCCHAMT, a.FRTAMNT,                                                                                                                                                                                        

a.TAXAMNT, a.TTLPYMTS, a.CURNCYID, a.PYMTRMID, a.SHIPMTHD, a.TAXSCHID,                                                                                                                                                                                        

a.PCHSCHID, a.FRTSCHID, a.MSCSCHID, a.PSTGDATE, a.DISAVTKN, a.CNTRLTYP,                                                                                                                                                                                      

a.NOTEINDX, a.PRCTDISC, a.RETNAGAM, '1900-01-01', a.ICTRX, a.Tax_Date,                                                                                                                                                                                        

a.PRCHDATE, a.CORRCTN, a.SIMPLIFD, a.APLYWITH, a.Electronic, a.ECTRX,                                                                                                                                                                                        

a.DocPrinted, a.TaxInvReqd, a.VNDCHKNM, a.BackoutTradeDisc, a.CBVAT

from PM20000 a

join ##PMMoveDebitOpenToHist b on a.VCHRNMBR = b.VCHRNMBR and a.DOCTYPE = b.DOCTYPE

delete a

from PM20000 a

join ##PMMoveDebitOpenToHist b on a.VCHRNMBR = b.VCHRNMBR and a.DOCTYPE = b.DOCTYPE

-- update keys

update a set a.DCSTATUS = 3

from PM00400 a

join ##PMMoveDebitOpenToHist b on a.CNTRLNUM = b.VCHRNMBR and a.DOCTYPE = b.DOCTYPE

-- move dist from open to hist

insert into PM30600

(DOCTYPE,VCHRNMBR,DSTSQNUM,CNTRLTYP,CRDTAMNT,DEBITAMT,                                                                                                                                                                                                          

DSTINDX,DISTTYPE,CHANGED,USERID,PSTGSTUS,VENDORID,                                                                                                                                                                                                            

TRXSORCE,PSTGDATE,CURNCYID,CURRNIDX,ORCRDAMT,ORDBTAMT,                                                                                                                                                                                                        

APTVCHNM,APTODCTY,SPCLDIST,DistRef)

select

b.DOCTYPE, a.VCHRNMBR, a.DSTSQNUM, a.CNTRLTYP, a.CRDTAMNT, a.DEBITAMT,                                                                                                                                                                                        

a.DSTINDX, a.DISTTYPE, a.CHANGED, a.USERID, a.PSTGSTUS, a.VENDORID,                                                                                                                                                                                          

a.TRXSORCE, a.PSTGDATE, a.CURNCYID, a.CURRNIDX, a.ORCRDAMT, a.ORDBTAMT,                                                                                                                                                                                      

a.APTVCHNM, a.APTODCTY, a.SPCLDIST, a.DistRef

from PM10100 a

join PM00400 b on a.VCHRNMBR = b.CNTRLNUM and a.CNTRLTYP = b.CNTRLTYP

join ##PMMoveDebitOpenToHist c on a.VCHRNMBR = c.VCHRNMBR and b.DOCTYPE = c.DOCTYPE

delete a

from PM10100 a

join PM00400 b on a.VCHRNMBR = b.CNTRLNUM and a.CNTRLTYP = b.CNTRLTYP

join ##PMMoveDebitOpenToHist c on a.VCHRNMBR = c.VCHRNMBR and b.DOCTYPE = c.DOCTYPE

-- move tax records from open to hist

insert into PM30700

(VENDORID,VCHRNMBR,DOCTYPE,BACHNUMB,TAXDTLID,BKOUTTAX,                                                                                                                                                                                                          

TAXAMNT,ORTAXAMT,PCTAXAMT,ORPURTAX,FRTTXAMT,ORFRTTAX,                                                                                                                                                                                                          

MSCTXAMT,ORMSCTAX,ACTINDX,TRXSORCE,TDTTXPUR,ORTXBPUR,                                                                                                                                                                                                          

TXDTTPUR,ORTOTPUR,CURRNIDX)

select

a.VENDORID, a.VCHRNMBR, a.DOCTYPE, a.BACHNUMB, a.TAXDTLID, a.BKOUTTAX,                                                                                                                                                                                        

a.TAXAMNT, a.ORTAXAMT, a.PCTAXAMT, a.ORPURTAX, a.FRTTXAMT, a.ORFRTTAX,                                                                                                                                                                                        

a.MSCTXAMT, a.ORMSCTAX, a.ACTINDX, a.TRXSORCE, a.TDTTXPUR, a.ORTXBPUR,                                                                                                                                                                                        

a.TXDTTPUR, a.ORTOTPUR, a.CURRNIDX

from PM10500 a

join ##PMMoveDebitOpenToHist b on a.VCHRNMBR = b.VCHRNMBR and a.DOCTYPE = b.DOCTYPE

delete a

from PM10500 a

join ##PMMoveDebitOpenToHist b on a.VCHRNMBR = b.VCHRNMBR and a.DOCTYPE = b.DOCTYPE

-- move applied records

insert into PM30300

(VENDORID,DOCDATE,DATE1,GLPOSTDT,TIME1,APTVCHNM,                                                                                                                                                                                                                

APTODCTY,APTODCNM,APTODCDT,ApplyToGLPostDate,CURNCYID,CURRNIDX,                                                                                                                                                                                                

APPLDAMT,DISTKNAM,DISAVTKN,WROFAMNT,ORAPPAMT,ORDISTKN,                                                                                                                                                                                                        

ORDATKN,ORWROFAM,APTOEXRATE,APTODENRATE,APTORTCLCMETH,APTOMCTRXSTT,                                                                                                                                                                                            

VCHRNMBR,DOCTYPE,APFRDCNM,ApplyFromGLPostDate,FROMCURR,APFRMAPLYAMT,                                                                                                                                                                                          

APFRMDISCTAKEN,APFRMDISCAVAIL,APFRMWROFAMT,ActualApplyToAmount,ActualDiscTakenAmount,ActualDiscAvailTaken,                                                                                                                                                    

ActualWriteOffAmount,APFRMEXRATE,APFRMDENRATE,APFRMRTCLCMETH,APFRMMCTRXSTT,PPSAMDED,                                                                                                                                                                          

GSTDSAMT,TAXDTLID,POSTED,TEN99AMNT,RLGANLOS,APYFRMRNDAMT,                                                                                                                                                                                                      

APYTORNDAMT,APYTORNDDISC,OAPYFRMRNDAMT,OAPYTORNDAMT,OAPYTORNDDISC,Settled_Gain_CreditCurrT,                                                                                                                                                                    

Settled_Loss_CreditCurrT,Settled_Gain_DebitCurrTr,Settled_Loss_DebitCurrTr,Settled_Gain_DebitDiscAv,Settled_Loss_DebitDiscAv,Revaluation_Status)

select

a.VENDORID, a.DOCDATE, a.DATE1, a.GLPOSTDT, a.TIME1, a.APTVCHNM,                                                                                                                                                                                              

a.APTODCTY, a.APTODCNM, a.APTODCDT, a.ApplyToGLPostDate, a.CURNCYID, a.CURRNIDX,                                                                                                                                                                              

a.APPLDAMT, a.DISTKNAM, a.DISAVTKN, a.WROFAMNT, a.ORAPPAMT, a.ORDISTKN,                                                                                                                                                                                      

a.ORDATKN, a.ORWROFAM, a.APTOEXRATE, a.APTODENRATE, a.APTORTCLCMETH, a.APTOMCTRXSTT,                                                                                                                                                                          

a.VCHRNMBR, a.DOCTYPE, a.APFRDCNM, a.ApplyFromGLPostDate, a.FROMCURR, a.APFRMAPLYAMT,                                                                                                                                                                        

a.APFRMDISCTAKEN, a.APFRMDISCAVAIL, a.APFRMWROFAMT, a.ActualApplyToAmount, a.ActualDiscTakenAmount, a.ActualDiscAvailTaken,                                                                                                                                  

a.ActualWriteOffAmount, a.APFRMEXRATE, a.APFRMDENRATE, a.APFRMRTCLCMETH, a.APFRMMCTRXSTT, a.PPSAMDED,                                                                                                                                                        

a.GSTDSAMT, a.TAXDTLID, a.POSTED, a.TEN99AMNT, a.RLGANLOS, a.APYFRMRNDAMT,                                                                                                                                                                                    

a.APYTORNDAMT, a.APYTORNDDISC, a.OAPYFRMRNDAMT, a.OAPYTORNDAMT, a.OAPYTORNDDISC, a.Settled_Gain_CreditCurrT,                                                                                                                                                  

a.Settled_Loss_CreditCurrT, a.Settled_Gain_DebitCurrTr, a.Settled_Loss_DebitCurrTr, a.Settled_Gain_DebitDiscAv, a.Settled_Loss_DebitDiscAv, a.Revaluation_Status

from PM10200 a

join ##PMMoveDebitOpenToHist b on a.APTVCHNM = b.VCHRNMBR and a.APTODCTY = b.DOCTYPE

left join PM30300 c on a.APTVCHNM = c.APTVCHNM and a.APTODCTY = c.APTODCTY and a.VCHRNMBR = c.VCHRNMBR and a.DOCTYPE = c.DOCTYPE

where c.VCHRNMBR is null

-- delete apply records that should not be in open

delete a

from PM10200 a

join ##PMMoveDebitOpenToHist b on a.APTVCHNM = b.VCHRNMBR and a.APTODCTY = b.DOCTYPE

join (select t1.CNTRLNUM, t1.DOCTYPE

from PM00400 t1

join (select distinct t2.VCHRNMBR, t2.DOCTYPE

from PM10200 t2

join ##PMMoveDebitOpenToHist t3 on t2.APTVCHNM = t3.VCHRNMBR and t2.APTODCTY = t3.DOCTYPE) t4

  on t1.CNTRLNUM = t4.VCHRNMBR and t1.DOCTYPE = t4.DOCTYPE

where t1.DCSTATUS <> 2) c on a.VCHRNMBR = c.CNTRLNUM and a.DOCTYPE = c.DOCTYPE