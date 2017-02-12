SELECT 
 i2.LOCNCODE as location,
i1.itemnmbr, 
       qtyonhnd
  FROM
       IV00101 i1 INNER JOIN IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode='0IN'
UNION
SELECT  
 i2.LOCNCODE as location,
i1.itemnmbr,
qtyonhnd
FROM
TPEUR.DBO.IV00101 i1 INNER JOIN TPEUR.DBO.IV00102 i2
ON i1.itemnmbr
=
i2.itemnmbr
WHERE itemtype<>2
AND i2.locncode='0EU'

UNION
SELECT i2.LOCNCODE as location,  
i1.itemnmbr, 
qtyonhnd
  FROM
       GICAN.DBO.IV00101 i1 INNER JOIN GICAN.DBO.IV00102 i2
       ON i1.itemnmbr
          =
          i2.itemnmbr
  WHERE itemtype<>2
    AND i2.locncode='0MT'