-- SOP Duplicates
SELECT SOPTYPE , 
       SOPNUMBE , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT SOPTYPE , 
               SOPNUMBE
          FROM SOP10100 W
        UNION ALL
        SELECT SOPTYPE , 
               SOPNUMBE
          FROM SOP30200 H
      )C
  GROUP BY SOPTYPE , 
           SOPNUMBE
  HAVING COUNT( *
              ) > 1;


-- IVC Duplicates
SELECT DOCTYPE , 
       INVCNMBR , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT DOCTYPE , 
               INVCNMBR
          FROM IVC10100 W
        UNION ALL
        SELECT DOCTYPE , 
               INVCNMBR
          FROM IVC30101 H
      )C
  GROUP BY DOCTYPE , 
           INVCNMBR
  HAVING COUNT( *
              ) > 1;


-- POP PO Duplicates
SELECT PONUMBER , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT PONUMBER
          FROM POP10100 W
        UNION ALL
        SELECT PONUMBER
          FROM POP30100 H
      )C
  GROUP BY PONUMBER
  HAVING COUNT( *
              ) > 1;


-- POP Receivingss Duplicates
SELECT POPRCTNM , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT POPRCTNM
          FROM POP10300 W
        UNION ALL
        SELECT POPRCTNM
          FROM POP30300 H
      )C
  GROUP BY POPRCTNM
  HAVING COUNT( *
              ) > 1;


-- RM Duplicates
SELECT RMDTYPAL , 
       DOCNUMBR , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT RMDTYPAL , 
               RMDNUMWK AS DOCNUMBR
          FROM RM10301 W
        UNION ALL
        SELECT RMDTYPAL , 
               DOCNUMBR
          FROM RM10201 W
        UNION ALL
        SELECT RMDTYPAL , 
               DOCNUMBR
          FROM RM20101 O
        UNION ALL
        SELECT RMDTYPAL , 
               DOCNUMBR
          FROM RM30101 H
      )C
  GROUP BY RMDTYPAL , 
           DOCNUMBR
  HAVING COUNT( *
              ) > 1;


-- PM Duplicates
SELECT DOCTYPE , 
       VCHRNMBR , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT DOCTYPE , 
               VCHNUMWK AS VCHRNMBR
          FROM PM10000 W
        UNION ALL
        SELECT DOCTYPE , 
               VCHRNMBR
          FROM PM10300 P
        UNION ALL
        SELECT DOCTYPE , 
               VCHRNMBR
          FROM PM10400 M
        UNION ALL
        SELECT DOCTYPE , 
               VCHRNMBR
          FROM PM20000 O
        UNION ALL
        SELECT DOCTYPE , 
               VCHRNMBR
          FROM PM30200 H
      )C
  GROUP BY DOCTYPE , 
           VCHRNMBR
  HAVING COUNT( *
              ) > 1;


-- IV Duplicates
SELECT IVDOCTYP , 
       DOCNUMBR , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT IVDOCTYP , 
               IVDOCNBR AS DOCNUMBR
          FROM IV10000 W
        UNION ALL
        SELECT IVDOCTYP , 
               DOCNUMBR
          FROM IV30200 H
      )C
  GROUP BY IVDOCTYP , 
           DOCNUMBR
  HAVING COUNT( *
              ) > 1;


-- GL Duplicates
SELECT JRNENTRY , 
       RCTRXSEQ , 
       SEQNUMBR , 
       ACTINDX , 
       TRXDATE , 
       CRDTAMNT , 
       DEBITAMT , 
       [YEAR] , 
       COUNT( *
            )AS COUNT
  FROM( 
        SELECT WH.JRNENTRY , 
               WH.RCTRXSEQ , 
               WL.SQNCLINE AS SEQNUMBR , 
               WL.ACTINDX , 
               TRXDATE , 
               CRDTAMNT , 
               DEBITAMT , 
               WH.OPENYEAR AS [YEAR]
          FROM
               GL10000 WH JOIN GL10001 WL
               ON WL.JRNENTRY
                  = 
                  WH.JRNENTRY
        UNION ALL
        SELECT JRNENTRY , 
               RCTRXSEQ , 
               SEQNUMBR , 
               ACTINDX , 
               TRXDATE , 
               CRDTAMNT , 
               DEBITAMT , 
               OPENYEAR AS [YEAR]
          FROM GL20000 O
        UNION ALL
        SELECT JRNENTRY , 
               RCTRXSEQ , 
               SEQNUMBR , 
               ACTINDX , 
               TRXDATE , 
               CRDTAMNT , 
               DEBITAMT , 
               HSTYEAR AS [YEAR]
          FROM GL30000 H
      )C
  GROUP BY JRNENTRY , 
           RCTRXSEQ , 
           SEQNUMBR , 
           ACTINDX , 
           TRXDATE , 
           CRDTAMNT , 
           DEBITAMT , 
           [YEAR]
  HAVING COUNT( *
              ) > 1;