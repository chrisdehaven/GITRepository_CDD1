SELECT  CASE A.RCPTSOLD
          WHEN 1 THEN 'Closed'
          WHEN 0 THEN 'Open'
          ELSE 'NA'
        END AS 'Cost Layer Status' ,
        A.RCPTNMBR AS 'In Receipt Number' ,
        CASE A.PCHSRCTY
          WHEN 1 THEN 'Adjustment'
          WHEN 2 THEN 'Variance'
          WHEN 3 THEN 'Transfer'
          WHEN 4 THEN 'Override'
          WHEN 5 THEN 'Receipt'
          WHEN 6 THEN 'Return'
          WHEN 7 THEN 'Assembly'
          WHEN 8 THEN 'In-Transit'
          ELSE 'NA'
        END AS 'In Transaction Type' ,
        A.DATERECD AS 'In Date Received' ,
        A.ITEMNMBR AS 'In Item Number' ,
        A.TRXLOCTN AS 'In Transaction Location' ,
        A.QTYRECVD AS 'In Quantity Received' ,
        A.QTYSOLD AS 'In Quantity Sold' ,
        A.UNITCOST AS 'In Unit Cost' ,
        A.RCTSEQNM AS 'In Receipt Sequence Number' ,
        ISNULL(B.ORIGInDOCID, ' ') AS 'Out Document Number' ,
        ISNULL(B.DOCDATE, ' ') AS 'Out Document Date' ,
        ISNULL(B.ITEMNMBR, ' ') AS 'Out Item Number' ,
        ISNULL(B.TRXLOCTN, ' ') AS 'Out Transaction Location' ,
        ISNULL(B.QTYSOLD, 0) AS 'Out Quantity Sold' ,
        ISNULL(B.UNITCOST, 0) AS 'Out Unit Cost' ,
        ISNULL(B.SRCRCTSEQNM, ' ') AS 'Out Source Receipt Sequence Number' ,
        ISNULL(C.SOPTYPE, ' ') AS 'SLS SOP Type' ,
        ISNULL(C.SOPNUMBE, ' ') AS 'SLS SOP Number' ,
        ISNULL(C.UNITPRCE, 0) AS 'SLS SOP Unit Price'
FROM    IV10200 AS A
        LEFT OUTER JOIN IV10201 AS B ON A.ITEMNMBR = B.ITEMNMBR
                                        AND A.TRXLOCTN = B.TRXLOCTN
                                        AND A.RCTSEQNM = B.SRCRCTSEQNM
        LEFT OUTER JOIN ( SELECT    CASE SOPTYPE
                                      WHEN 1 THEN 'Quote'
                                      WHEN 2 THEN 'Order'
                                      WHEN 3 THEN 'Invoice'
                                      WHEN 4 THEN 'Return'
                                      WHEN 5 THEN 'Back Order'
                                      WHEN 6 THEN 'Fulfillment Order'
                                      ELSE 'NA'
                                    END AS SOPTYPE ,
                                    SOPNUMBE ,
                                    ITEMNMBR ,
                                    LOCNCODE ,
                                    UNITCOST ,
                                    UNITPRCE
                          FROM      SOP30300
                        ) AS C ON B.ORIGInDOCID = C.SOPNUMBE
                                  AND B.ITEMNMBR = C.ITEMNMBR
                                  AND B.TRXLOCTN = C.LOCNCODE
                                 -- where [in date received]>='1/1/2015'
                                  order by [in item number]
                                  ,[in date received]
 