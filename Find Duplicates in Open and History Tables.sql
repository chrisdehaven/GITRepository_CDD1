-- SOP Duplicates
select SOPTYPE, SOPNUMBE, COUNT(*) as [COUNT] from 
(
select 'sop10100' as [table],SOPTYPE, SOPNUMBE from SOP10100 W
UNION ALL
select 'sop30300' as [table],SOPTYPE, SOPNUMBE from SOP30200 H
) C
group by SOPTYPE, SOPNUMBE
having COUNT(*) > 1


-- IVC Duplicates
select DOCTYPE, INVCNMBR, COUNT(*) as [COUNT] from 
(
select DOCTYPE, INVCNMBR from IVC10100 W
UNION ALL
select DOCTYPE, INVCNMBR from IVC30101 H
) C
group by DOCTYPE, INVCNMBR
having COUNT(*) > 1


-- POP PO Duplicates
select PONUMBER, COUNT(*) as [COUNT] from 
(
select PONUMBER from POP10100 W
UNION ALL
select PONUMBER from POP30100 H
) C
group by PONUMBER
having COUNT(*) > 1


-- POP Receivingss Duplicates
select POPRCTNM, COUNT(*) as [COUNT] from 
(
select POPRCTNM from POP10300 W
UNION ALL
select POPRCTNM from POP30300 H
) C
group by POPRCTNM
having COUNT(*) > 1


-- RM Duplicates
select RMDTYPAL, DOCNUMBR, COUNT(*) as [COUNT] from 
(
select RMDTYPAL, RMDNUMWK as DOCNUMBR from RM10301 W
UNION ALL
select RMDTYPAL, DOCNUMBR from RM10201 W
UNION ALL
select RMDTYPAL, DOCNUMBR from RM20101 O
UNION ALL
select RMDTYPAL, DOCNUMBR from RM30101 H
) C
group by RMDTYPAL, DOCNUMBR
having COUNT(*) > 1


-- PM Duplicates
select DOCTYPE, VCHRNMBR, COUNT(*) as [COUNT] from 
(
select DOCTYPE, VCHNUMWK as VCHRNMBR from PM10000 W
UNION ALL
select DOCTYPE, VCHRNMBR from PM10300 P
UNION ALL
select DOCTYPE, VCHRNMBR from PM10400 M
UNION ALL
select DOCTYPE, VCHRNMBR from PM20000 O
UNION ALL
select DOCTYPE, VCHRNMBR from PM30200 H
) C
group by DOCTYPE, VCHRNMBR
having COUNT(*) > 1


-- IV Duplicates
select IVDOCTYP, DOCNUMBR, COUNT(*) as [COUNT] from 
(
select IVDOCTYP, IVDOCNBR as DOCNUMBR from IV10000 W
UNION ALL
select IVDOCTYP, DOCNUMBR from IV30200 H
) C
group by IVDOCTYP, DOCNUMBR
having COUNT(*) > 1


-- GL Duplicates
select JRNENTRY, RCTRXSEQ, SEQNUMBR, ACTINDX, TRXDATE, CRDTAMNT, DEBITAMT, [YEAR], COUNT(*) as [COUNT] from 
(
select WH.JRNENTRY, WH.RCTRXSEQ, WL.SQNCLINE as SEQNUMBR, WL.ACTINDX, TRXDATE, CRDTAMNT, DEBITAMT, WH.OPENYEAR as [YEAR] from GL10000 WH JOIN GL10001 WL ON WL.JRNENTRY = WH.JRNENTRY
UNION ALL
select JRNENTRY, RCTRXSEQ, SEQNUMBR, ACTINDX, TRXDATE, CRDTAMNT, DEBITAMT, OPENYEAR as [YEAR] from GL20000 O
UNION ALL
select JRNENTRY, RCTRXSEQ, SEQNUMBR, ACTINDX, TRXDATE, CRDTAMNT, DEBITAMT, HSTYEAR as [YEAR] from GL30000 H
) C
group by JRNENTRY, RCTRXSEQ, SEQNUMBR, ACTINDX, TRXDATE, CRDTAMNT, DEBITAMT, [YEAR]
having COUNT(*) > 1