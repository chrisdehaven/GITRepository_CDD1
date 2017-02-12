SELECT 'TPSPT' as Company,
C1.VENDORID as 'VendorID',
C1M.VENDNAME as 'VendorName', C1.DOCDATE as 'InvoiceDate',
C1.DOCNUMBR as 'DocumentNumber',
CASE C1.DOCTYPE
WHEN 1 THEN 'Invoice'
WHEN 2 THEN 'Finance Charge'
WHEN 3 THEN 'Misc Charge'
END AS 'DocumentType', C1.VCHRNMBR as 'VoucherNumber',
C1.DOCAMNT as 'DocumentAmount', C1.CURTRXAM as 'CurrentTrxAmount',
C1.TRXDSCRN as 'TransactionDescription', C1.DUEDATE as 'DueDate'
 
-- ***** Replace Comp1 with 1st company database ID *****
FROM tpspt.dbo.PM20000 C1
LEFT OUTER JOIN
 
-- ***** Replace Comp1 with 1st company database ID *****
tpspt.dbo.PM00200 C1M
ON C1.VENDORID = C1M.VENDORID
WHERE C1.DOCTYPE in (1,2,3)
 
UNION ALL
 
-- ***** Replace Company2 with 2nd company name *****
SELECT 'TPEUR' as Company,
C2.VENDORID as 'VendorID',
C2M.VENDNAME as 'VendorName', C2.DOCDATE as 'InvoiceDate',
C2.DOCNUMBR as 'DocumentNumber',
CASE C2.DOCTYPE
WHEN 1 THEN 'Invoice'
WHEN 2 THEN 'Finance Charge'
WHEN 3 THEN 'Misc Charge'
END AS 'DocumentType', C2.VCHRNMBR as 'VoucherNumber',
C2.DOCAMNT as 'DocumentAmount', C2.CURTRXAM as 'CurrentTrxAmount',
C2.TRXDSCRN as 'TransactionDescription', C2.DUEDATE as 'DueDate'
 
-- ***** Replace Comp2 with 2nd company database ID *****
FROM tpeur.dbo.PM20000 C2
LEFT OUTER JOIN
 
-- ***** Replace Comp2 with 2nd company database ID *****
tpeur.dbo.PM00200 C2M
ON C2.VENDORID = C2M.VENDORID
WHERE C2.DOCTYPE in (1,2,3)
 
UNION ALL
 
-- ***** Replace Company3 with 3rd company name *****
SELECT 'GICAN' as Company,
C3.VENDORID as 'VendorID',
C3M.VENDNAME as 'VendorName', C3.DOCDATE as 'InvoiceDate',
C3.DOCNUMBR as 'DocumentNumber',
CASE C3.DOCTYPE
WHEN 1 THEN 'Invoice'
WHEN 2 THEN 'Finance Charge'
WHEN 3 THEN 'Misc Charge'
END AS 'DocumentType', C3.VCHRNMBR as 'VoucherNumber',
C3.DOCAMNT as 'DocumentAmount', C3.CURTRXAM as 'CurrentTrxAmount',
C3.TRXDSCRN as 'TransactionDescription', C3.DUEDATE as 'DueDate'
 
-- ***** Replace Comp3 with 3rd company database ID *****
FROM gican.dbo.PM20000 C3
LEFT OUTER JOIN
 
-- ***** Replace Comp3 with 3rd company database ID *****
gican.dbo.PM00200 C3M
ON C3.VENDORID = C3M.VENDORID
WHERE C3.DOCTYPE in (1,2,3)