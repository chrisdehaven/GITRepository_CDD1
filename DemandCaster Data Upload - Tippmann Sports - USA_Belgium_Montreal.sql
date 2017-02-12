
/*
BELGIUM FROM TPEUR ------------------------------------------------------
*/

--Item1:

SELECT 'BELGIUM' AS COUNTRY, i1.itemnmbr, 
       itemdesc, 
       qtyonhnd, 
       ordrpntqty, 
       PRCHSNGLDTM AS stagingldtme, 
       mnmmordrqty, 
       primvndr, 
       uomschdl, 
       itmclscd, 
       currcost, 
       orderpolicy AS inventory, 
       'B' AS makebuy, 
       mnmmordrqty AS casepack, 
       0 AS casecube, 
       sftystckqty,
0 as unitprice,
0 as storage
  FROM
       TPEUR.DBO.IV00101 i1 INNER JOIN TPEUR.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
      AND i1.locncode
          =
          i2.locncode
  WHERE itemtype<>2
  ORDER BY i1.itemnmbr;

--Item2:

SELECT 'BELGIUM' AS COUNTRY,  i1.itemnmbr, 
       qtyonhnd
  FROM
       TPEUR.DBO.IV00101 i1 INNER JOIN TPEUR.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode=''
  ORDER BY i1.itemnmbr;

--Product Class:

select
'BELGIUM' AS COUNTRY, ITMCLSCD as 'code',
ITMCLSDC as 'name'
from TPEUR.DBO.IV40400

--Vendors:

select  'BELGIUM' AS COUNTRY, vendorid, vendname
from TPEUR.DBO.PM00200

--Customers:

select distinct  'BELGIUM' AS COUNTRY, [USERDEF2] as custnmbr, 
        [USERDEF2] as custname 
from TPEUR.DBO.RM00101

--Customer Orders Open:

SELECT 'BELGIUM' AS COUNTRY,  header.SOPNUMBE,
       'O' AS status,
       header.DOCDATE,
       cust.[USERDEF2] as CUSTNMBR,
       detail.ITEMNMBR,
       detail.QTYREMAI*detail.QTYBSUOM AS qtyorder,
       detail.ReqShipDate,
       detail.ACTLSHIP,
       detail.QTYFULFI*detail.QTYBSUOM AS shipqty,
       detail.UNITPRCE AS salesprice,
       detail.UNITCOST AS cost,
       header.VOIDSTTS
  FROM
       TPEUR.DBO.SOP10100 AS header 
        INNER JOIN TPEUR.DBO.SOP10200 AS detail ON header.SOPNUMBE = detail.SOPNUMBE AND header.SOPTYPE = detail.SOPTYPE
        INNER JOIN TPEUR.DBO.RM00101 AS cust ON header.CUSTNMBR = cust.CUSTNMBR
  WHERE header.DOCDATE >= CONVERT (datetime, '2012-01-01 00:00:00', 102)
    AND header.VOIDSTTS = 0
    AND (detail.SOPTYPE = 2 OR detail.SOPTYPE = 3)
    AND header.PSTGSTUS = 0
    AND detail.UNITPRCE <>0;

--Customer Orders Closed:

SELECT 'BELGIUM' AS COUNTRY,  p1.ponumber, 
       p2.polnesta AS postatus, 
       p1.docdate, 
       p2.vendorid, 
       p2.itemnmbr, 
       p2.qtyorder, 
       p2.prmdate, 
       SUM (p3.qtyshppd) AS qtyshppd, 
       MAX (p3.daterecd) AS daterecd
  FROM
       TPEUR.DBO.POP10100 p1 INNER JOIN TPEUR.DBO.POP10110 p2
       ON p1.ponumber = p2.ponumber 
        LEFT OUTER JOIN TPEUR.DBO.POP10500 p3
       ON p2.ponumber=p3.ponumber
      AND p2.ord=p3.polnenum
  WHERE p1.docdate> '2005-1-1'
    AND p2.polnesta<6
  GROUP BY p1.ponumber, 
           p2.polnesta, 
           p1.docdate, 
           p2.vendorid, 
           p2.itemnmbr, 
           p2.qtyorder, 
           p2.prmdate, 
           p2.ord;


/*
NORTH AMERICA FROM TPSPT ----------------------------------------------------------------
*/
--Item1:

SELECT 'NORTH AMERICA' AS COUNTRY,  i1.itemnmbr, 
       itemdesc, 
       qtyonhnd, 
       ordrpntqty, 
       PRCHSNGLDTM AS stagingldtme, 
       mnmmordrqty, 
       primvndr, 
       uomschdl, 
       itmclscd, 
       currcost, 
       orderpolicy AS inventory, 
       'B' AS makebuy, 
       mnmmordrqty AS casepack, 
       0 AS casecube, 
       sftystckqty,
0 as unitprice,
0 as storage
  FROM
       TPSPT.DBO.IV00101 i1 INNER JOIN TPSPT.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
      AND i1.locncode
          =
          i2.locncode
  WHERE itemtype<>2
  ORDER BY i1.itemnmbr;

--Item2:

SELECT 'NORTH AMERICA' AS COUNTRY,  i1.itemnmbr, 
       qtyonhnd
  FROM
       TPSPT.DBO.IV00101 i1 INNER JOIN TPSPT.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode=''
  ORDER BY i1.itemnmbr;

--Product Class:

select
'NORTH AMERICA' AS COUNTRY, ITMCLSCD as 'code',
ITMCLSDC as 'name'
from TPSPT.DBO.IV40400

--Vendors:

select  
'NORTH AMERICA' AS COUNTRY, vendorid, vendname
from TPSPT.DBO.PM00200

--Customers:

select distinct  'NORTH AMERICA' AS COUNTRY, [USERDEF2] as custnmbr, 
        [USERDEF2] as custname 
from TPSPT.DBO.RM00101

--Customer Orders Open:

SELECT 
 'NORTH AMERICA' AS COUNTRY, header.SOPNUMBE,
       'O' AS status,
       header.DOCDATE,
       cust.[USERDEF2] as CUSTNMBR,
       detail.ITEMNMBR,
       detail.QTYREMAI*detail.QTYBSUOM AS qtyorder,
       detail.ReqShipDate,
       detail.ACTLSHIP,
       detail.QTYFULFI*detail.QTYBSUOM AS shipqty,
       detail.UNITPRCE AS salesprice,
       detail.UNITCOST AS cost,
       header.VOIDSTTS
  FROM
       TPSPT.DBO.SOP10100 AS header 
        INNER JOIN TPSPT.DBO.SOP10200 AS detail ON header.SOPNUMBE = detail.SOPNUMBE AND header.SOPTYPE = detail.SOPTYPE
        INNER JOIN TPSPT.DBO.RM00101 AS cust ON header.CUSTNMBR = cust.CUSTNMBR
  WHERE header.DOCDATE >= CONVERT (datetime, '2012-01-01 00:00:00', 102)
    AND header.VOIDSTTS = 0
    AND (detail.SOPTYPE = 2 OR detail.SOPTYPE = 3)
    AND header.PSTGSTUS = 0
    AND detail.UNITPRCE <>0;

--Customer Orders Closed:

SELECT 'NORTH AMERICA' AS COUNTRY,  p1.ponumber, 
       p2.polnesta AS postatus, 
       p1.docdate, 
       p2.vendorid, 
       p2.itemnmbr, 
       p2.qtyorder, 
       p2.prmdate, 
       SUM (p3.qtyshppd) AS qtyshppd, 
       MAX (p3.daterecd) AS daterecd
  FROM
       TPSPT.DBO.POP10100 p1 INNER JOIN TPSPT.DBO.POP10110 p2
       ON p1.ponumber = p2.ponumber 
        LEFT OUTER JOIN TPSPT.DBO.POP10500 p3
       ON p2.ponumber=p3.ponumber
      AND p2.ord=p3.polnenum
  WHERE p1.docdate> '2005-1-1'
    AND p2.polnesta<6
  GROUP BY p1.ponumber, 
           p2.polnesta, 
           p1.docdate, 
           p2.vendorid, 
           p2.itemnmbr, 
           p2.qtyorder, 
           p2.prmdate, 
           p2.ord;



/*

MONTREAL FROM GICAN -----------------------------------------------------------------

*/

--Item1:

SELECT 'MONTREAL' AS COUNTRY, i1.itemnmbr, 
       itemdesc, 
       qtyonhnd, 
       ordrpntqty, 
       PRCHSNGLDTM AS stagingldtme, 
       mnmmordrqty, 
       primvndr, 
       uomschdl, 
       itmclscd, 
       currcost, 
       orderpolicy AS inventory, 
       'B' AS makebuy, 
       mnmmordrqty AS casepack, 
       0 AS casecube, 
       sftystckqty,
0 as unitprice,
0 as storage
  FROM
       GICAN.DBO.IV00101 i1 INNER JOIN GICAN.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
      AND i1.locncode
          =
          i2.locncode
  WHERE itemtype<>2
  ORDER BY i1.itemnmbr;

--Item2:

SELECT 'MONTREAL' AS COUNTRY,  i1.itemnmbr, 
       qtyonhnd
  FROM
       GICAN.DBO.IV00101 i1 INNER JOIN GICAN.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode=''
  ORDER BY i1.itemnmbr;

--Product Class:

select
'MONTREAL' AS COUNTRY, ITMCLSCD as 'code',
ITMCLSDC as 'name'
from GICAN.DBO.IV40400

--Vendors:

select  'MONTREAL' AS COUNTRY, vendorid, vendname
from GICAN.DBO.PM00200

--Customers:

select distinct  'MONTREAL' AS COUNTRY, [USERDEF2] as custnmbr, 
        [USERDEF2] as custname 
from GICAN.DBO.RM00101

--Customer Orders Open:

SELECT 'MONTREAL' AS COUNTRY,  header.SOPNUMBE,
       'O' AS status,
       header.DOCDATE,
       cust.[USERDEF2] as CUSTNMBR,
       detail.ITEMNMBR,
       detail.QTYREMAI*detail.QTYBSUOM AS qtyorder,
       detail.ReqShipDate,
       detail.ACTLSHIP,
       detail.QTYFULFI*detail.QTYBSUOM AS shipqty,
       detail.UNITPRCE AS salesprice,
       detail.UNITCOST AS cost,
       header.VOIDSTTS
  FROM
       GICAN.DBO.SOP10100 AS header 
        INNER JOIN GICAN.DBO.SOP10200 AS detail ON header.SOPNUMBE = detail.SOPNUMBE AND header.SOPTYPE = detail.SOPTYPE
        INNER JOIN GICAN.DBO.RM00101 AS cust ON header.CUSTNMBR = cust.CUSTNMBR
  WHERE header.DOCDATE >= CONVERT (datetime, '2012-01-01 00:00:00', 102)
    AND header.VOIDSTTS = 0
    AND (detail.SOPTYPE = 2 OR detail.SOPTYPE = 3)
    AND header.PSTGSTUS = 0
    AND detail.UNITPRCE <>0;

--Customer Orders Closed:

SELECT 'MONTREAL' AS COUNTRY,  p1.ponumber, 
       p2.polnesta AS postatus, 
       p1.docdate, 
       p2.vendorid, 
       p2.itemnmbr, 
       p2.qtyorder, 
       p2.prmdate, 
       SUM (p3.qtyshppd) AS qtyshppd, 
       MAX (p3.daterecd) AS daterecd
  FROM
       GICAN.DBO.POP10100 p1 INNER JOIN GICAN.DBO.POP10110 p2
       ON p1.ponumber = p2.ponumber 
        LEFT OUTER JOIN GICAN.DBO.POP10500 p3
       ON p2.ponumber=p3.ponumber
      AND p2.ord=p3.polnenum
  WHERE p1.docdate> '2005-1-1'
    AND p2.polnesta<6
  GROUP BY p1.ponumber, 
           p2.polnesta, 
           p1.docdate, 
           p2.vendorid, 
           p2.itemnmbr, 
           p2.qtyorder, 
           p2.prmdate, 
           p2.ord;


