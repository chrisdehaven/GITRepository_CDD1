USE TPSPT;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER OFF;
GO
CREATE PROCEDURE dbo.ivReconcileSearch @I_cTableName char (25) =NULL, 
                                       @O_RecordCount int=NULL OUTPUT, 
                                       @O_SQL_Error_State int=0 OUTPUT
    WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
       @x2 char (20) , 
       @x3 integer, 
       @ENABLEMULTIBIN tinyint;
    SELECT @x2='', 
           @x3=0, 
           @ENABLEMULTIBIN=0;
    DELETE TAIVRec;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#ReconcileItems')) 
        BEGIN
            DROP TABLE #ReconcileItems;
        END;
    CREATE TABLE #ReconcileItems (ITEMNMBR char (31) , 
                                  LOCNCODE char (11) , 
                                  REASON varchar (150)) ;
    CREATE INDEX PKReconcileItems ON #ReconcileItems (ITEMNMBR, LOCNCODE)
;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV00102Detail')) 
        BEGIN
            DROP TABLE #IV00102Detail;
        END;
    CREATE TABLE #IV00102Detail (ITEMNMBR char (31) , 
                                 SumATYALLOC numeric (19, 5) , 
                                 SumQTYONHND numeric (19, 5)) ;
    CREATE INDEX PKIV00102Detail ON #IV00102Detail (ITEMNMBR) ;
    INSERT INTO #IV00102Detail
    SELECT s.ITEMNMBR, 
           SUM (s.ATYALLOC) , 
           SUM (s.QTYONHND)
      FROM IV00102 s, IV00101 m
      WHERE s.RCRDTYPE<>1
        AND s.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2
      GROUP BY s.ITEMNMBR;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Quantity Allocated or Quantity on Hand did not match for Locations'
      FROM IV00102 i, #IV00102Detail d, IV00101 m
      WHERE i.RCRDTYPE=1
        AND i.ITEMNMBR
            =
            d.ITEMNMBR
        AND (i.ATYALLOC
             <>
             d.SumATYALLOC
          OR i.QTYONHND
             <>
             d.SumQTYONHND)
        AND i.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2;
    INSERT INTO #ReconcileItems
    SELECT s.ITEMNMBR, 
           s.LOCNCODE,
'Quantity on Hand for Item Number/Location did not have corresponding Purchase Receipt'
      FROM IV00102 s
      WHERE s.QTYONHND<>0
        AND s.LOCNCODE+s.ITEMNMBR NOT IN (
                                          SELECT i2.TRXLOCTN+i2.ITEMNMBR
                                            FROM IV10200 i2)
        AND s.RCRDTYPE<>1;
    INSERT INTO #ReconcileItems
    SELECT a.ITEMNMBR, 
           '', 
           'On Order Quantity does not match'
      FROM IV00102 a, (
                       SELECT ITEMNMBR, 
                              SUM (QTYUNCMTBASE) AS SUMQTYUNCMTBASE
                         FROM POP10110
                         WHERE POLNESTA IN (2, 3)
                           AND POTYPE IN (1, 3)
                           AND LineNumber<>0
                           AND NONINVEN=0
                         GROUP BY ITEMNMBR) b
      WHERE a.ITEMNMBR
            =
            b.ITEMNMBR
        AND a.QTYONORD
            <>
            b.SUMQTYUNCMTBASE
        AND a.LOCNCODE='';
    INSERT INTO #ReconcileItems
    SELECT DISTINCT ITEMNMBR, 
                    '', 
                    'On Order Quantity contained negative value'
      FROM IV00102
      WHERE QTYONORD<0;
    INSERT INTO #ReconcileItems
    SELECT DISTINCT a.ITEMNMBR, 
                    a.TRXLOCTN, 
                    'Quantity in Purchase Receipts does not match Purchase Receipts Detail'
      FROM IV10200 a, (
                       SELECT ITEMNMBR, 
                              SRCRCTSEQNM, 
                              SUM (QTYSOLD) AS SUMQTYSOLD
                         FROM IV10201
                         GROUP BY ITEMNMBR, 
                                  SRCRCTSEQNM) b, IV00101 c
      WHERE a.ITEMNMBR
            =
            b.ITEMNMBR
        AND a.RCTSEQNM
            =
            b.SRCRCTSEQNM
        AND a.QTYSOLD
            <>
            b.SUMQTYSOLD
        AND a.VCTNMTHD<>0
        AND a.ITEMNMBR
            =
            c.ITEMNMBR
        AND c.ITEMTYPE IN (1, 2) ;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#SOP10200Sum')) 
        BEGIN
            DROP TABLE #SOP10200Sum;
        END;
    CREATE TABLE #SOP10200Sum (ITEMNMBR char (31) , 
                               LOCNCODE char (11) , 
                               SumATYALLOC numeric (19, 5)) ;
    CREATE INDEX PKSOP10200SumItem ON #SOP10200Sum (ITEMNMBR, LOCNCODE) ;
    CREATE INDEX AK1SOP10200SumLocncode ON #SOP10200Sum (LOCNCODE,
ITEMNMBR) ;
    INSERT INTO #SOP10200Sum (ITEMNMBR, 
                              LOCNCODE, 
                              SumATYALLOC) 
    SELECT d.ITEMNMBR, 
           d.LOCNCODE, 
           SUM (d.ATYALLOC*QTYBSUOM)
      FROM SOP10200 d, IV00101 m
      WHERE d.DROPSHIP=0
        AND d.SOPTYPE IN (2, 3, 6)
        AND d.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2
        AND d.TRXSORCE=''
      GROUP BY d.ITEMNMBR, 
               d.LOCNCODE;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV10001Sum')) 
        BEGIN
            DROP TABLE #IV10001Sum;
        END;
    CREATE TABLE #IV10001Sum (ITEMNMBR char (31) , 
                              LOCNCODE char (11) , 
                              SumTRXQTY numeric (19, 5)) ;
    CREATE INDEX PKIV10001SumItem ON #IV10001Sum (ITEMNMBR, LOCNCODE) ;
    CREATE INDEX AK1IV10001SumLocncode ON #IV10001Sum (LOCNCODE, ITEMNMBR)
;
    INSERT INTO #IV10001Sum (ITEMNMBR, 
                             LOCNCODE, 
                             SumTRXQTY) 
    SELECT t.ITEMNMBR, 
           t.TRXLOCTN, 
           SUM (qty)
      FROM (
            SELECT i.ITEMNMBR, 
                   i.TRXLOCTN, 
                   SUM (ABS (i.TRXQTY*QTYBSUOM)) qty
              FROM IV10001 i, IV00101 m
              WHERE(i.IVDOCTYP IN (1, 2)
                AND i.TRXQTY<0
                 OR i.IVDOCTYP=3)
               AND i.ITEMNMBR
                   =
                   m.ITEMNMBR
               AND m.ITEMTYPE<=2
               AND i.TRFQTYTY IN (0, 1)
              GROUP BY i.ITEMNMBR, 
                       i.TRXLOCTN
            UNION
            SELECT i.ITEMNMBR, 
                   i.LOCNCODE, 
                   SUM (ISNULL (i.ATYALLOC*QTYBSUOM, 0)) qty
              FROM IV00101 m, BM10300 i
              WHERE i.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
                AND m.ITEMNMBR
                    =
                    i.ITEMNMBR
              GROUP BY i.ITEMNMBR, 
                       i.LOCNCODE) t
      GROUP BY t.ITEMNMBR, 
               t.TRXLOCTN;
    IF EXISTS (SELECT 1
                 FROM sysobjects
                 WHERE name
                       =
                       'SVC00203') 
        BEGIN
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#SVC00203Sum')) 
                BEGIN
                    DROP TABLE #SVC00203Sum;
                END;
            CREATE TABLE #SVC00203Sum (ITEMNMBR char (31) , 
                                       LOCNCODE char (11) , 
                                       SumATYALLOC numeric (19, 5)) ;
            CREATE INDEX PKSVC00203SumItem ON #SVC00203Sum (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1SVC00203SumLocncode ON #SVC00203Sum (LOCNCODE,
ITEMNMBR) ;
            INSERT INTO #SVC00203Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT s.ITEMNMBR, 
                   s.LOCNCODE, 
                   SUM (s.ATYALLOC)
              FROM SVC00203 s, IV00101 m
              WHERE s.SRVRECTYPE=2
                AND s.LINITMTYP
                    =
                    'P'
                AND s.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY s.ITEMNMBR, 
                       s.LOCNCODE;
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#SVC06100Sum')) 
                BEGIN
                    DROP TABLE #SVC06100Sum;
                END;
            CREATE TABLE #SVC06100Sum (ITEMNMBR char (31) , 
                                       LOCNCODE char (11) , 
                                       SumATYALLOC numeric (19, 5)) ;
            CREATE INDEX PKSVC06100SumItem ON #SVC06100Sum (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1SVC06100SumLocncode ON #SVC06100Sum (LOCNCODE,
ITEMNMBR) ;
            INSERT INTO #SVC06100Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT s.IBITEMNUM, 
                   s.LOCNCODE, 
                   SUM (s.QUANTITY)
              FROM SVC06100 s, IV00101 m
              WHERE s.WORECTYPE=2
                AND s.IBITEMNUM
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY s.IBITEMNUM, 
                       s.LOCNCODE;
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#SVC06101Sum')) 
                BEGIN
                    DROP TABLE #SVC06101Sum;
                END;
            CREATE TABLE #SVC06101Sum (ITEMNMBR char (31) , 
                                       LOCNCODE char (11) , 
                                       SumATYALLOC numeric (19, 5)) ;
            CREATE INDEX PKSVC06101SumItem ON #SVC06101Sum (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1SVC06101SumLocncode ON #SVC06101Sum (LOCNCODE,
ITEMNMBR) ;
            INSERT INTO #SVC06101Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT s.ITEMNMBR, 
                   s.LOCNCODE, 
                   SUM (s.ATYALLOC)
              FROM SVC06101 s, IV00101 m
              WHERE s.WORECTYPE=2
                AND s.LINITMTYP
                    =
                    'P'
                AND s.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY s.ITEMNMBR, 
                       s.LOCNCODE;
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#SVC00701Sum')) 
                BEGIN
                    DROP TABLE #SVC00701Sum;
                END;
            CREATE TABLE #SVC00701Sum (ITEMNMBR char (31) , 
                                       LOCNCODE char (11) , 
                                       SumATYALLOC numeric (19, 5)) ;
            CREATE INDEX PKSVC00701SumItem ON #SVC00701Sum (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1SVC00701SumLocncode ON #SVC00701Sum (LOCNCODE,
ITEMNMBR) ;
            INSERT INTO #SVC00701Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT l.ITEMNMBR, 
                   h.TRNSFLOC, 
                   SUM (TRNSFQTY-QTYSHPPD)
              FROM SVC00701 l, SVC00700 h, IV00101 m
              WHERE l.ORDDOCID
                    =
                    h.ORDDOCID
                AND l.STATUS<4
                AND l.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY l.ITEMNMBR, 
                       h.TRNSFLOC;
            INSERT INTO #SVC00701Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT l.ITEMNMBR, 
                   h.ITLOCN, 
                   SUM (l.QTYSHPPD-l.QTY_To_Receive)
              FROM SVC00701 l, SVC00700 h, IV00101 m
              WHERE l.ORDDOCID
                    =
                    h.ORDDOCID
                AND l.STATUS=5
                AND l.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY l.ITEMNMBR, 
                       h.ITLOCN;
            INSERT INTO #SVC00701Sum (ITEMNMBR, 
                                      LOCNCODE, 
                                      SumATYALLOC) 
            SELECT l.ITEMNMBR, 
                   h.ITLOCN, 
                   SUM (l.QTYSHPPD)
              FROM SVC00701 l, SVC00700 h, IV00101 m
              WHERE l.ORDDOCID
                    =
                    h.ORDDOCID
                AND l.STATUS=4
                AND l.ITEMNMBR
                    =
                    m.ITEMNMBR
                AND m.ITEMTYPE<=2
              GROUP BY l.ITEMNMBR, 
                       h.ITLOCN;
        END;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#POP10500Sum')) 
        BEGIN
            DROP TABLE #POP10500Sum;
        END;
    CREATE TABLE #POP10500Sum (ITEMNMBR char (31) , 
                               LOCNCODE char (11) , 
                               SumQTYRESERVED numeric (19, 5)) ;
    CREATE INDEX PKPOP10500SumItem ON #POP10500Sum (ITEMNMBR, LOCNCODE) ;
    CREATE INDEX AK1POP10500SumLocncode ON #POP10500Sum (LOCNCODE,
ITEMNMBR) ;
    INSERT INTO #POP10500Sum (ITEMNMBR, 
                              LOCNCODE, 
                              SumQTYRESERVED) 
    SELECT a.ITEMNMBR, 
           b.LOCNCODE, 
           SUM (a.QTYRESERVED*a.UMQTYINB)
      FROM
           POP10500 a JOIN POP10310 b
           ON a.POPRCTNM
              =
              b.POPRCTNM
          AND a.RCPTLNNM
              =
              b.RCPTLNNM
          AND a.ITEMNMBR
              =
              b.ITEMNMBR
      WHERE a.QTYRESERVED
            >
            0
      GROUP BY a.ITEMNMBR, 
               b.LOCNCODE;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#CombinedStep1')) 
        BEGIN
            DROP TABLE #CombinedStep1;
        END;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#Combined')) 
        BEGIN
            DROP TABLE #Combined;
        END;
    CREATE TABLE #CombinedStep1 (ITEMNMBR char (31) , 
                                 LOCNCODE char (11) , 
                                 SumQty numeric (19, 5)) ;
    CREATE TABLE #Combined (ITEMNMBR char (31) , 
                            LOCNCODE char (11) , 
                            SumQty numeric (19, 5)) ;
    INSERT INTO #CombinedStep1
    SELECT *
      FROM #SOP10200Sum
      WHERE SumATYALLOC<>0;
    IF EXISTS (SELECT 1
                 FROM sysobjects
                 WHERE name
                       =
                       'SVC00203') 
        BEGIN
            INSERT INTO #CombinedStep1
            SELECT *
              FROM #SVC00203Sum
              WHERE SumATYALLOC<>0;
            INSERT INTO #CombinedStep1
            SELECT *
              FROM #SVC06100Sum
              WHERE SumATYALLOC<>0;
            INSERT INTO #CombinedStep1
            SELECT *
              FROM #SVC06101Sum
              WHERE SumATYALLOC<>0;
            INSERT INTO #CombinedStep1
            SELECT *
              FROM #SVC00701Sum
              WHERE SumATYALLOC<>0;
        END;
    INSERT INTO #CombinedStep1
    SELECT *
      FROM #IV10001Sum
      WHERE SumTRXQTY<>0;
    INSERT INTO #CombinedStep1
    SELECT *
      FROM #POP10500Sum
      WHERE SumQTYRESERVED
            <>
            0;
    INSERT INTO #Combined
    SELECT ITEMNMBR, 
           LOCNCODE, 
           SUM (SumQty)
      FROM #CombinedStep1
      GROUP BY ITEMNMBR, 
               LOCNCODE;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Allocated quantities do not match from detail to IV00102'
      FROM IV00102 i, #Combined d, IV00101 m
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.LOCNCODE
        AND i.ATYALLOC
            <>
            d.SumQty
        AND i.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           '', 
           'IV00102 has allocations with no matching detail'
      FROM IV00102 i, IV00101 m
      WHERE i.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2
        AND i.LOCNCODE=''
        AND i.ATYALLOC>0
        AND i.ITEMNMBR NOT IN (
                               SELECT ITEMNMBR
                                 FROM #Combined) ;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV10200Sum')) 
        BEGIN
            DROP TABLE #IV10200Sum;
        END;
    CREATE TABLE #IV10200Sum (ITEMNMBR char (31) , 
                              TRXLOCTN char (11) , 
                              QTYTYPE tinyint, 
                              OVRQTY numeric (19, 5) , 
                              SumQTYRECVD numeric (19, 5)) ;
    CREATE INDEX PKIV10200SumItem ON #IV10200Sum (ITEMNMBR, TRXLOCTN) ;
    CREATE INDEX AK1IV10200SumTrxloctn ON #IV10200Sum (TRXLOCTN, ITEMNMBR)
;
    INSERT INTO #IV10200Sum (ITEMNMBR, 
                             TRXLOCTN, 
                             QTYTYPE, 
                             OVRQTY, 
                             SumQTYRECVD) 
    SELECT i.ITEMNMBR, 
           i.TRXLOCTN, 
           QTYTYPE, 
           0, 
           SUM (i.QTYRECVD-i.QTYSOLD)
      FROM IV10200 i, IV00101 m
      WHERE i.QTYRECVD
            <>
            i.QTYSOLD
        AND i.ITEMNMBR
            =
            m.ITEMNMBR
        AND m.ITEMTYPE<=2
      GROUP BY i.ITEMNMBR, 
               i.TRXLOCTN, 
               i.QTYTYPE;
    UPDATE a SET a.OVRQTY=d.SERLTQTY
      FROM #IV10200Sum a, (SELECT b.ITEMNMBR, 
                                  LOCNCODE, 
                                  SUM (b.SERLTQTY) SERLTQTY
                             FROM SOP10201 b, SOP10200 c
                             WHERE b.SOPTYPE
                                   =
                                   c.SOPTYPE
                               AND b.SOPNUMBE
                                   =
                                   c.SOPNUMBE
                               AND b.LNITMSEQ
                                   =
                                   c.LNITMSEQ
                               AND b.OVRSERLT=1
                               AND b.POSTED=0
                             GROUP BY b.ITEMNMBR, 
                                      LOCNCODE) d
      WHERE a.ITEMNMBR
            =
            d.ITEMNMBR
        AND a.TRXLOCTN
            =
            d.LOCNCODE
        AND a.QTYTYPE=1;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Qty Type in Item Qty Master does not match Purchase Receipts'
      FROM IV00102 i, #IV10200Sum d
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.TRXLOCTN
        AND (i.QTYONHND
             <>
             d.SumQTYRECVD+OVRQTY
         AND d.QTYTYPE=1
          OR i.QTYRTRND
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=2
          OR i.QTYINUSE
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=3
          OR i.QTYINSVC
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=4
          OR i.QTYDMGED
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=5);
    INSERT INTO #ReconcileItems
    SELECT ITEMNMBR, 
           '', 
           'Blank Serial Number or Location Code'
      FROM IV00200
      WHERE SERLNMBR=''
         OR LOCNCODE='';
    INSERT INTO #ReconcileItems
    SELECT ITEMNMBR, 
           '', 
           'Blank Lot Number or Location Code'
      FROM IV00300
      WHERE LOTNUMBR=''
         OR LOCNCODE='';
    INSERT INTO #ReconcileItems
    SELECT DISTINCT ITEMNMBR, 
                    '', 
                    'Negative Quantity Allocated'
      FROM IV00102
      WHERE ATYALLOC<0;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV00200SumQTYONHND')) 
        BEGIN
            DROP TABLE #IV00200SumQTYONHND;
        END;
    CREATE TABLE #IV00200SumQTYONHND (ITEMNMBR char (31) , 
                                      LOCNCODE char (11) , 
                                      QTYTYPE tinyint, 
                                      SumQTYONHND numeric (19, 5)) ;
    CREATE INDEX PKIV00200SumItem ON #IV00200SumQTYONHND (ITEMNMBR,
LOCNCODE) ;
    CREATE INDEX AK1IV00200SumLOCNCODE ON #IV00200SumQTYONHND (LOCNCODE,
ITEMNMBR) ;
    INSERT INTO #IV00200SumQTYONHND (ITEMNMBR, 
                                     LOCNCODE, 
                                     QTYTYPE, 
                                     SumQTYONHND) 
    SELECT ITEMNMBR, 
           LOCNCODE, 
           QTYTYPE, 
           COUNT (*)
      FROM IV00200
      GROUP BY ITEMNMBR, 
               LOCNCODE, 
               QTYTYPE;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Qty Type in Serial Number Master does not match Item Qty Master table'
      FROM IV00102 i, #IV00200SumQTYONHND d
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.LOCNCODE
        AND (i.QTYONHND
             <>
             d.SumQTYONHND
         AND d.QTYTYPE=1
          OR i.QTYRTRND
             <>
             d.SumQTYONHND
         AND d.QTYTYPE=2
          OR i.QTYINUSE
             <>
             d.SumQTYONHND
         AND d.QTYTYPE=3
          OR i.QTYINSVC
             <>
             d.SumQTYONHND
         AND d.QTYTYPE=4
          OR i.QTYDMGED
             <>
             d.SumQTYONHND
         AND d.QTYTYPE=5);
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV00200SumATYALLOC')) 
        BEGIN
            DROP TABLE #IV00200SumATYALLOC;
        END;
    CREATE TABLE #IV00200SumATYALLOC (ITEMNMBR char (31) , 
                                      LOCNCODE char (11) , 
                                      QTY numeric (19, 5) , 
                                      SumATYALLOC numeric (19, 5)) ;
    CREATE INDEX PKIV00200SumItem ON #IV00200SumATYALLOC (ITEMNMBR,
LOCNCODE) ;
    CREATE INDEX AK1IV00200SumLOCNCODE ON #IV00200SumATYALLOC (LOCNCODE,
ITEMNMBR) ;
    INSERT INTO #IV00200SumATYALLOC (ITEMNMBR, 
                                     LOCNCODE, 
                                     QTY, 
                                     SumATYALLOC) 
    SELECT ITEMNMBR, 
           LOCNCODE, 
           0, 
           SUM (SERLNSLD)
      FROM IV00200
      WHERE SERLNSLD=1
      GROUP BY ITEMNMBR, 
               LOCNCODE, 
               QTYTYPE;
    UPDATE a SET a.QTY=d.QTY
      FROM #IV00200SumATYALLOC a, (SELECT b.ITEMNMBR, 
                                          LOCNCODE, 
                                          SUM (b.ATYALLOC-b.QTYFULFI) QTY
                                     FROM SOP10200 b
                                     GROUP BY b.ITEMNMBR, 
                                              LOCNCODE) d
      WHERE a.ITEMNMBR
            =
            d.ITEMNMBR
        AND a.LOCNCODE
            =
            d.LOCNCODE;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Serial Number Master Qty Allocated does not match Item Quantity Master'
      FROM IV00102 i, #IV00200SumATYALLOC d
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.LOCNCODE
        AND i.ATYALLOC
            <>
            d.SumATYALLOC+d.QTY;
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV00300Sum')) 
        BEGIN
            DROP TABLE #IV00300Sum;
        END;
    CREATE TABLE #IV00300Sum (ITEMNMBR char (31) , 
                              LOCNCODE char (11) , 
                              QTYTYPE tinyint, 
                              SumQTYRECVD numeric (19, 5) , 
                              SumATYALLOC numeric (19, 5)) ;
    CREATE INDEX PKIV00300SumItem ON #IV00300Sum (ITEMNMBR, LOCNCODE) ;
    CREATE INDEX AK1IV00300SumLOCNCODE ON #IV00300Sum (LOCNCODE, ITEMNMBR)
;
    INSERT INTO #IV00300Sum (ITEMNMBR, 
                             LOCNCODE, 
                             QTYTYPE, 
                             SumQTYRECVD, 
                             SumATYALLOC) 
    SELECT ITEMNMBR, 
           LOCNCODE, 
           QTYTYPE, 
           SUM (QTYRECVD-QTYSOLD) , 
           SUM (ATYALLOC)
      FROM IV00300
      GROUP BY ITEMNMBR, 
               LOCNCODE, 
               QTYTYPE;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Quantity Type in Lot Number Master does not match Item Quantity Master'
      FROM IV00102 i, #IV00300Sum d
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.LOCNCODE
        AND (i.QTYONHND
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=1
          OR i.QTYRTRND
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=2
          OR i.QTYINUSE
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=3
          OR i.QTYINSVC
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=4
          OR i.QTYDMGED
             <>
             d.SumQTYRECVD
         AND d.QTYTYPE=5);
    IF EXISTS (SELECT 1
                 FROM tempdb..sysobjects
                 WHERE id
                       =
                       OBJECT_ID ('tempdb..#IV00300SumATYALLOC')) 
        BEGIN
            DROP TABLE #IV00300SumATYALLOC;
        END;
    CREATE TABLE #IV00300SumATYALLOC (ITEMNMBR char (31) , 
                                      LOCNCODE char (11) , 
                                      QTY numeric (19, 5) , 
                                      SumATYALLOC numeric (19, 5)) ;
    CREATE INDEX PKIV00300SumItem ON #IV00300SumATYALLOC (ITEMNMBR,
LOCNCODE) ;
    CREATE INDEX AK1IV00300SumLOCNCODE ON #IV00300SumATYALLOC (LOCNCODE,
ITEMNMBR) ;
    INSERT INTO #IV00300SumATYALLOC (ITEMNMBR, 
                                     LOCNCODE, 
                                     QTY, 
                                     SumATYALLOC) 
    SELECT ITEMNMBR, 
           LOCNCODE, 
           0, 
           SUM (ATYALLOC)
      FROM IV00300
      GROUP BY ITEMNMBR, 
               LOCNCODE;
    UPDATE a SET a.QTY=d.QTY
      FROM #IV00300SumATYALLOC a, (SELECT b.ITEMNMBR, 
                                          LOCNCODE, 
                                          SUM (b.QTYBSUOM*b.ATYALLOC-(b.
QTYBSUOM*b.QTYFULFI)) QTY
                                     FROM SOP10200 b
                                     GROUP BY b.ITEMNMBR, 
                                              LOCNCODE) d
      WHERE a.ITEMNMBR
            =
            d.ITEMNMBR
        AND a.LOCNCODE
            =
            d.LOCNCODE;
    INSERT INTO #ReconcileItems
    SELECT i.ITEMNMBR, 
           i.LOCNCODE, 
           'Lot Number Master Qty Allocated does not match Item Quantity Master'
      FROM IV00102 i, #IV00300SumATYALLOC d
      WHERE i.ITEMNMBR
            =
            d.ITEMNMBR
        AND i.LOCNCODE
            =
            d.LOCNCODE
        AND i.ATYALLOC
            <>
            d.SumATYALLOC+d.QTY;
    SELECT @ENABLEMULTIBIN=ENABLEMULTIBIN
      FROM IV40100 (nolock)
      WHERE SETUPKEY=1;
    IF @ENABLEMULTIBIN
       =
       1
        BEGIN
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#IV00112SumLoc')) 
                BEGIN
                    DROP TABLE #IV00112SumLoc;
                END;
            CREATE TABLE #IV00112SumLoc (ITEMNMBR char (31) , 
                                         LOCNCODE char (11) , 
                                         QTY numeric (19, 5)) ;
            CREATE INDEX PKIV00112SumLoc ON #IV00112SumLoc (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1IV00112SumLoc ON #IV00112SumLoc (LOCNCODE,
ITEMNMBR) ;
            INSERT INTO #IV00112SumLoc (ITEMNMBR, 
                                        LOCNCODE, 
                                        QTY) 
            SELECT ITEMNMBR, 
                   '', 
                   ISNULL (SUM (QUANTITY-ATYALLOC) , 0)
              FROM IV00112 (nolock)
              WHERE QTYTYPE=1
              GROUP BY ITEMNMBR;
            UPDATE a SET a.QTY=a.QTY-d.QTY
              FROM #IV00112SumLoc a, (SELECT b.ITEMNMBR, 
                                             ISNULL (SUM (b.QTYBSUOM*b.
ATYALLOC-(b.QTYBSUOM*b.QTYFULFI)) , 0) QTY
                                        FROM SOP10200 b
                                        GROUP BY b.ITEMNMBR) d
              WHERE a.ITEMNMBR
                    =
                    d.ITEMNMBR;
            INSERT INTO #ReconcileItems
            SELECT a.ITEMNMBR, 
                   '',
'Item Site Bin Master Qty Allocated does not match Item Quantity Master Qty Allocated summary record'
              FROM IV00102 a, #IV00112SumLoc b
              WHERE a.ITEMNMBR
                    =
                    b.ITEMNMBR
                AND a.LOCNCODE=''
                AND a.QTYONHND-a.ATYALLOC
                    <>
                    b.QTY;
            INSERT INTO #ReconcileItems
            SELECT ITEMNMBR, 
                   LOCNCODE,
'Item Site Bin Master Qty Allocated has allocations for records other then On Hand'
              FROM IV00112
              WHERE ATYALLOC>0
                AND QTYTYPE<>1;
            IF EXISTS (SELECT 1
                         FROM tempdb..sysobjects
                         WHERE id
                               =
                               OBJECT_ID ('tempdb..#IV00112DetailLoc')) 
                BEGIN
                    DROP TABLE #IV00112DetailLoc;
                END;
            CREATE TABLE #IV00112DetailLoc (ITEMNMBR char (31) , 
                                            LOCNCODE char (11) , 
                                            QTY numeric (19, 5)) ;
            CREATE INDEX PKIV00112DetailLoc ON #IV00112DetailLoc (ITEMNMBR,
LOCNCODE) ;
            CREATE INDEX AK1IV00112DetailLoc ON #IV00112DetailLoc (
LOCNCODE, ITEMNMBR) ;
            INSERT INTO #IV00112DetailLoc (ITEMNMBR, 
                                           LOCNCODE, 
                                           QTY) 
            SELECT ITEMNMBR, 
                   LOCNCODE, 
                   ISNULL (SUM (QUANTITY-ATYALLOC) , 0)
              FROM IV00112 (nolock)
              WHERE QTYTYPE=1
              GROUP BY ITEMNMBR, 
                       LOCNCODE;
            UPDATE a SET a.QTY=a.QTY-d.QTY
              FROM #IV00112DetailLoc a, (SELECT b.ITEMNMBR, 
                                                LOCNCODE, 
                                                ISNULL (SUM (b.QTYBSUOM*b.
ATYALLOC-(b.QTYBSUOM*b.QTYFULFI)) , 0) QTY
                                           FROM SOP10200 b
                                           GROUP BY b.ITEMNMBR, 
                                                    LOCNCODE) d
              WHERE a.ITEMNMBR
                    =
                    d.ITEMNMBR
                AND a.LOCNCODE
                    =
                    d.LOCNCODE;
            INSERT INTO #ReconcileItems
            SELECT a.ITEMNMBR, 
                   a.LOCNCODE,
'Item Site Bin Master Qty Allocated does not match Item Quantity Master Qty Allocated detail'
              FROM IV00102 a, #IV00112DetailLoc b
              WHERE a.ITEMNMBR
                    =
                    b.ITEMNMBR
                AND a.LOCNCODE
                    =
                    b.LOCNCODE
                AND a.QTYONHND-a.ATYALLOC
                    <>
                    b.QTY;
            INSERT INTO #ReconcileItems
            SELECT DISTINCT ITEMNMBR, 
                            '', 
                            'Invalid Bin, Bin not set up in Site Bin Master'
              FROM IV10002 (nolock)
              WHERE FROMBIN NOT IN (
                                    SELECT BIN
                                      FROM IV40701 (nolock)) ;
            INSERT INTO #ReconcileItems
            SELECT DISTINCT ITEMNMBR, 
                            '', 
                            'Invalid Bin, Bin not set up in Site Bin Master'
              FROM IV10003 (nolock)
              WHERE BIN NOT IN (
                                SELECT BIN
                                  FROM IV40701 (nolock)) ;
            INSERT INTO #ReconcileItems
            SELECT DISTINCT ITEMNMBR, 
                            '', 
                            'Invalid Bin, Bin not set up in Site Bin Master'
              FROM IV10002 (nolock)
              WHERE TOBIN NOT IN (
                                  SELECT BIN
                                    FROM IV40701 (nolock))
                AND IVDOCTYP NOT IN (1, 2) ;
            INSERT INTO #ReconcileItems
            SELECT DISTINCT ITEMNMBR, 
                            '', 
                            'Invalid Bin, Bin not set up in Site Bin Master'
              FROM IV10003 (nolock)
              WHERE TOBIN NOT IN (
                                  SELECT BIN
                                    FROM IV40701 (nolock))
                AND IVDOCTYP NOT IN (1, 2) ;
            INSERT INTO #ReconcileItems
            SELECT ITEMNMBR, 
                   '', 
                   'Bin Number is blank in Serial Number Master'
              FROM IV00200
              WHERE BIN='';
            INSERT INTO #ReconcileItems
            SELECT ITEMNMBR, 
                   '', 
                   'Bin Number is blank in Lot Number Master'
              FROM IV00300
              WHERE BIN='';
            IF EXISTS (SELECT 1
                         FROM sysobjects
                         WHERE name
                               =
                               'SVC00203') 
                BEGIN
                    INSERT INTO #ReconcileItems
                    SELECT a.ITEMNMBR, 
                           '',
'Field Service Quantity Allocated in Bin Work does not match Service Call Line Detail'
                      FROM
                           SVC00203 a INNER JOIN SVC00212 b
                           ON a.SRVRECTYPE
                              =
                              b.SRVRECTYPE
                          AND a.CALLNBR
                              =
                              b.CALLNBR
                          AND a.EQPLINE
                              =
                              b.EQPLINE
                          AND a.LINITMTYP
                              =
                              b.LINITMTYP
                          AND a.LNITMSEQ
                              =
                              b.LNITMSEQ
                      WHERE a.QTYSOLD=0
                        AND a.SRVRECTYPE
                            <>
                            3
                      GROUP BY a.ITEMNMBR, 
                               b.SRVRECTYPE, 
                               b.CALLNBR, 
                               b.EQPLINE, 
                               b.LINITMTYP, 
                               b.LNITMSEQ, 
                               a.ATYALLOC, 
                               a.QTYSOLD
                      HAVING a.ATYALLOC
                             <>
                             SUM (b.QUANTITY)
                         AND a.QTYSOLD=0;
                END;
        END;
    INSERT INTO TAIVRec (ITEMNMBR, 
                         LOCNCODE, 
                         TAIVRecReason) 
    SELECT ITEMNMBR, 
           LOCNCODE, 
           REASON
      FROM #ReconcileItems
      ORDER BY ITEMNMBR;
    EXEC ('insert into '+@I_cTableName+
' select distinct ITEMNMBR from #ReconcileItems') ;
    SELECT @O_RecordCount=0;
    SELECT @O_RecordCount=@O_RecordCount+1, 
           @x2=ITEMNMBR, 
           @x3=COUNT (*)
      FROM #ReconcileItems
      GROUP BY ITEMNMBR;
    SET NOCOUNT OFF;
    RETURN;
END; 
GO
