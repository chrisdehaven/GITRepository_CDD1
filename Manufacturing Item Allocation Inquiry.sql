Select  w.MANUFACTUREORDER_I,

m.ITEMNMBR,

w.STRTDATE,

m.TRXQTY-m.QTY_ISSUED_I,

w.MANUFACTUREORDERST_I  

from MOP1210 m, MOP1200 m0, WO010032 w

where w.MANUFACTUREORDER_I = m.MANUFACTUREORDER_I

and w.MANUFACTUREORDERST_I = 6

and m.PICKNUMBER = m0.PICKNUMBER

and m.TRX_TYPE in (3)

and m0.posted = 0

and (m.TRXQTY-m.QTY_ISSUED_I) > 0

--#3 With MO #'s only

Select  Distinct w.MANUFACTUREORDER_I  

from MOP1210 m, MOP1200 m0, WO010032 w

where w.MANUFACTUREORDER_I = m.MANUFACTUREORDER_I

and w.MANUFACTUREORDERST_I = 5

and m.PICKNUMBER = m0.PICKNUMBER

and m.TRX_TYPE in (3)

and m0.posted = 0

and (m.TRXQTY-m.QTY_ISSUED_I) > 0

--#1 Mike confirms this is an older query and is less accurate than 2 & 3 (20120326) - this query picks up adjustments as erros, but allocations match

Select TRXQTY,ISSUEDQTY, TRXQTY-ISSUEDQTY as ALLOCATEDDETAIL, (I.ATYALLOC-(Select SUM(ATYALLOC) from SOP10200 where ITEMNMBR = I.ITEMNMBR)) as ITEMALLOCATION, rtrim(I.ITEMNMBR) as ITEMNMBR  from

(

select rtrim(MOPL.ITEMNMBR) as ITEMNMBR,SUM(MOPL.TRXQTY) as TRXQTY, sum(MOPL.QTY_ISSUED_I) as ISSUEDQTY  from MOP1210 MOPL (Nolock)

inner join WO010032 WO (Nolock)

on wo.MANUFACTUREORDER_I = MOPL.MANUFACTUREORDER_I

inner join MOP1200 MOPM (Nolock)

on MOPM.PICKNUMBER = MOPL.PICKNUMBER

and wo.MANUFACTUREORDERST_I <> 8

and mopm.POSTED = 0

--and mop.ATYALLOC !=0

--and mop.QTY_ISSUED_I !=0

and MOPL.TRX_TYPE = 3

--Order By wo.MANUFACTUREORDER_I

group by MOPL.ITEMNMBR

) a, IV00102 I where I.ITEMNMBR = a.ITEMNMBR and I.LOCNCODE = 'WAREHOUSE' and (TRXQTY-ISSUEDQTY) != (I.ATYALLOC-(Select SUM(ATYALLOC) from SOP10200 where ITEMNMBR = I.ITEMNMBR))

order by ITEMNMBR