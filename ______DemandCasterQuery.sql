--Item1

SELECT i1.itemnmbr, 
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
       sftystckqty
  FROM
       IV00101 i1 INNER JOIN IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
      AND i1.locncode
          =
          i2.locncode
  WHERE itemtype<>2
  ORDER BY i1.itemnmbr;


--item 2
SELECT i1.itemnmbr, 
       qtyonhnd
  FROM
       IV00101 i1 INNER JOIN IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode=''
  ORDER BY i1.itemnmbr;


--ProductClass:
SELECT ITMCLSCD AS 'code', 
       ITMCLSDC AS 'name'
  FROM IV40400;

--Vendors
SELECT vendorid, 
       vendname
  FROM PM00200;


--Customers
SELECT custnmbr, 
       custname
  FROM RM00101;


--Orders Open
SELECT header.SOPNUMBE, 
       'O' AS status, 
       header.DOCDATE, 
       header.CUSTNMBR, 
       detail.ITEMNMBR, 
       detail.QTYREMAI*detail.QTYBSUOM AS qtyorder, 
       detail.ReqShipDate, 
       detail.ACTLSHIP, 
       detail.QTYFULFI*detail.QTYBSUOM AS shipqty, 
       detail.UNITPRCE AS salesprice, 
       detail.UNITCOST AS cost,
       header.VOIDSTTS
  FROM
       dbo.SOP10100 AS header INNER JOIN dbo.SOP10200 AS detail
       ON header.SOPNUMBE
          =
          detail.SOPNUMBE
      AND header.SOPTYPE
          =
          detail.SOPTYPE
  WHERE header.DOCDATE
        >=
        CONVERT (datetime, '2012-01-01 00:00:00', 102)
    AND header.VOIDSTTS
        =
        0
    AND (detail.SOPTYPE
         =
         2
      OR detail.SOPTYPE
         =
         3)
    AND header.PSTGSTUS
        =
        0
        
    AND detail.UNITPRCE <>0;
--Orders Closed
SELECT header.SOPNUMBE, 
       'C' AS status, 
       header.DOCDATE, 
       header.CUSTNMBR, 
       detail.ITEMNMBR, 
       detail.QUANTITY*detail.QTYBSUOM AS qtyorder, 
       header.ReqShipDate, 
       detail.ACTLSHIP, 
       detail.QTYPRINV*detail.QTYBSUOM AS shipqty, 
       detail.UNITPRCE as salesprice, 
       detail.UNITCOST AS cost,
       header.VOIDSTTS 
     
  FROM
       dbo.SOP30200 AS header INNER JOIN dbo.SOP30300 AS detail
       ON header.SOPNUMBE
          =
          detail.SOPNUMBE
      AND header.SOPTYPE
          =
          detail.SOPTYPE
  WHERE header.DOCDATE
        >
        '2012-1-1'
    AND header.VOIDSTTS
        =
        0
    AND (detail.SOPTYPE
         =
         2
      OR detail.SOPTYPE
         =
         3)
    AND header.PSTGSTUS
        =
        0
        
    AND  detail.UNITPRCE<>0; 
       



--Vendor Orders
SELECT p1.ponumber, 
       p2.polnesta AS postatus, 
       p1.docdate, 
       p2.vendorid, 
       p2.itemnmbr, 
       p2.qtyorder, 
       p2.prmdate, 
       SUM (p3.qtyshppd) AS qtyshppd, 
       MAX (p3.daterecd) AS daterecd
  FROM
       POP10100 p1 INNER JOIN POP10110 p2
       ON p1.ponumber
          =
          p2.ponumber
                   LEFT OUTER JOIN POP10500 p3
       ON p2.ponumber
          =
          p3.ponumber
      AND p2.ord
          =
          p3.polnenum
  WHERE p1.docdate
        >
        '2005-1-1'
    AND p2.polnesta<6
  GROUP BY p1.ponumber, 
           p2.polnesta, 
           p1.docdate, 
           p2.vendorid, 
           p2.itemnmbr, 
           p2.qtyorder, 
           p2.prmdate, 
           p2.ord;
