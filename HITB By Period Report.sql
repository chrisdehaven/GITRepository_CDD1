SELECT Year AS Trx_Year,
       Period,
       Item,
       Quantity AS QuantityBalance,
       Cost AS CostBalance,
       LOCNCODE
FROM(
    SELECT LOCNCODE,
           Year,
           Period,
           Date,
           Item,
           Quantity,
           Cost
    FROM(
        SELECT E.LOCNCODE,
               E.ITEMNMBR AS Item,
               E.YEAR1 AS Year,
               E.PERIODID AS Period,
               ISNULL(F.Quantity, 0) AS Quantity,
               ISNULL(F.Cost, 0) AS Cost,
               E.YEAR1*365+E.PERIODID*30 AS Date
        FROM(
            SELECT Z_1.LOCNCODE,
                   Z_1.ITEMNMBR,
                   D.YEAR1,
                   D.PERIODID
            FROM(
                SELECT DISTINCT YEAR1,
                                PERIODID,
                                DATEADD(mm, 1, CONVERT( DATETIME, '01/'+CAST(PERIODID AS VARCHAR(2))+'/'+CAST(YEAR1 AS VARCHAR(4)), 103)) AS Date
                FROM dbo.SY40100 AS X
                WHERE PERIODID<>0) AS D
            INNER JOIN
            (
                SELECT LOCNCODE,
                       ITEMNMBR,
                       MIN(DOCDATE) AS Date
                FROM dbo.SEE30303 AS Y
                GROUP BY LOCNCODE,
                         ITEMNMBR) AS Z_1
            ON D.Date>Z_1.Date) AS E
        LEFT OUTER JOIN
        (
            SELECT LOCNCODE,
                   YEAR(DOCDATE) AS Year,
                   MONTH(DOCDATE) AS Period,
                   ITEMNMBR AS Item,
                   SUM(TRXQTYInBase) AS Quantity,
                   SUM(EXTDCOST) AS Cost
            FROM dbo.SEE30303
            GROUP BY LOCNCODE,
                     YEAR(DOCDATE),
                     MONTH(DOCDATE),
                     ITEMNMBR) AS F
        ON E.ITEMNMBR=F.Item
       AND E.PERIODID=F.Period
       AND E.YEAR1=F.Year) AS X_1
    GROUP BY 
    
    LOCNCODE,Year,
             Period,
             Date,
             Item,
             Quantity,
             Cost) AS Z
             
             where Year='2015' and period='8'
             
             and Quantity<>0