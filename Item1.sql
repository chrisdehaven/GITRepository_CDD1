SELECT i2.LOCNCODE AS location , 
       i1.ITEMNMBR , 
       i1.ITEMDESC , 
       i2.QTYONHND , 
       i2.ORDRPNTQTY , 
       i2.PRCHSNGLDTM AS stagingldtme , 
       i2.MNMMORDRQTY , 
       i2.PRIMVNDR , 
       i1.UOMSCHDL , 
       i1.ITMCLSCD , 
       i1.CURRCOST , 
       i2.ORDERPOLICY AS inventory , 
       'B' AS makebuy , 
       i2.MNMMORDRQTY AS casepack , 
       0 AS casecube , 
       i2.SFTYSTCKQTY , 
       0 AS unitprice , 
       0 AS storage
  FROM
       tpspt.dbo.IV00101 AS i1 INNER JOIN
                               tpspt.dbo.IV00102 AS i2
  ON i1.ITEMNMBR
     = 
     i2.ITEMNMBR
  WHERE i1.ITEMTYPE <> 2
    AND i2.LOCNCODE
        = 
        '0IN'
UNION
SELECT i2.LOCNCODE AS location , 
       i1.ITEMNMBR , 
       i1.ITEMDESC , 
       i2.QTYONHND , 
       i2.ORDRPNTQTY , 
       i2.PRCHSNGLDTM AS stagingldtme , 
       i2.MNMMORDRQTY , 
       i2.PRIMVNDR , 
       i1.UOMSCHDL , 
       i1.ITMCLSCD , 
       i1.CURRCOST , 
       i2.ORDERPOLICY AS inventory , 
       'B' AS makebuy , 
       i2.MNMMORDRQTY AS casepack , 
       0 AS casecube , 
       i2.SFTYSTCKQTY , 
       0 AS unitprice , 
       0 AS storage
  FROM
       TPEUR.dbo.IV00101 AS i1 INNER JOIN
                               TPEUR.dbo.IV00102 AS i2
  ON i1.ITEMNMBR
     = 
     i2.ITEMNMBR
  WHERE i1.ITEMTYPE <> 2
    AND i2.LOCNCODE
        = 
        '0EU'
UNION
SELECT i2.LOCNCODE AS location , 
       i1.ITEMNMBR , 
       i1.ITEMDESC , 
       i2.QTYONHND , 
       i2.ORDRPNTQTY , 
       i2.PRCHSNGLDTM AS stagingldtme , 
       i2.MNMMORDRQTY , 
       i2.PRIMVNDR , 
       i1.UOMSCHDL , 
       i1.ITMCLSCD , 
       i1.CURRCOST , 
       i2.ORDERPOLICY AS inventory , 
       'B' AS makebuy , 
       i2.MNMMORDRQTY AS casepack , 
       0 AS casecube , 
       i2.SFTYSTCKQTY , 
       0 AS unitprice , 
       0 AS storage
  FROM
       GICAN.dbo.IV00101 AS i1 INNER JOIN
                               GICAN.dbo.IV00102 AS i2
  ON i1.ITEMNMBR
     = 
     i2.ITEMNMBR
  WHERE i1.ITEMTYPE <> 2
    AND i2.LOCNCODE
        = 
        '0MT';