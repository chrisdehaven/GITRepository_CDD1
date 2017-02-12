/******************************************************************
 
Tables used:
 - IV30300 - Inventory Transaction Amounts History
 - IV00102 - Item Quantity Master
 ******************************************************************/
SELECT A.ITEMNUMBER ,
        A.LOCATION ,
        B.QTYONHND AS QUANTITYONHAND ,
        SUM(A.QUANTITY) AS QUANTITY
    FROM (
          SELECT ITEMNMBR AS ITEMNUMBER ,
                TRXLOCTN AS LOCATION ,
                TRXQTY AS QUANTITY
            FROM dbo.IV30300
            WHERE DOCTYPE <> 3
          UNION ALL
          SELECT ITEMNMBR AS ITEMNUMBER ,
                TRXLOCTN AS LOCATION ,
                (TRXQTY * -1) AS QUANTITY
            FROM dbo.IV30300
            WHERE DOCTYPE = 3
          UNION ALL
          SELECT ITEMNMBR AS ITEMNUMBER ,
                TRNSTLOC AS LOCATION ,
                (TRXQTY) AS QUANTITY
            FROM dbo.IV30300
            WHERE DOCTYPE = 3
         ) A
        INNER JOIN IV00102 B
        ON A.ITEMNUMBER = B.ITEMNMBR
           AND A.LOCATION = B.LOCNCODE
    GROUP BY A.ITEMNUMBER ,
        A.LOCATION ,
        B.QTYONHND
    ORDER BY A.ITEMNUMBER ,
        A.LOCATION ,
        B.QTYONHND
