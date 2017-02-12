SELECT TOP ( 100
           )PERCENT CONVERT( char( 10
                                 ) , dbo.GL20000.TRXDATE , 101
                           )AS TransactionDate , 
                    dbo.GL00105.ACTNUMST , 
                    dbo.GL00100.ACTDESCR , 
                    dbo.GL20000.DEBITAMT , 
                    dbo.GL20000.CRDTAMNT , 
                    dbo.GL20000.OPENYEAR , 
                    dbo.GL20000.PERIODID , 
                    MONTH( dbo.GL20000.TRXDATE
                         )AS Month , 
                    dbo.GL20000.DEBITAMT - dbo.GL20000.CRDTAMNT AS NetAmount , 
                    dbo.GL00102.ACCATNUM AS AccountCategory , 
                    dbo.GL00102.ACCATDSC AS AccountCategoryDescription , 
                    P.PERNAME , 
                    CONVERT( char( 10
                                 ) , dbo.SY40101.FSTFSCDY , 101
                           )AS FirstDayOfYear , 
                    CONVERT( char( 10
                                 ) , dbo.SY40101.LSTFSCDY , 101
                           )AS LastDayOfYear , 
                    dbo.GL20000.REFRENCE , 
                    dbo.GL20000.DSCRIPTN , 
                    dbo.GL20000.ORMSTRID AS VendorOrCustomerID , 
                    dbo.GL20000.ORMSTRNM AS VendorOrCustomerName , 
                    dbo.GL20000.ORDOCNUM AS SubledgerDocumentNumber , 
                    dbo.GL20000.SERIES , 
                    dbo.GL20000.USWHPSTD , 
                    dbo.GL20000.JRNENTRY
  FROM
       dbo.GL20000 INNER JOIN dbo.GL00105
       ON dbo.GL20000.ACTINDX
          = 
          dbo.GL00105.ACTINDX
                   INNER JOIN dbo.GL00100
       ON dbo.GL00105.ACTINDX
          = 
          dbo.GL00100.ACTINDX
                   INNER JOIN dbo.GL00102
       ON dbo.GL00100.ACCATNUM
          = 
          dbo.GL00102.ACCATNUM
                   INNER JOIN dbo.SY40101
       ON dbo.GL20000.OPENYEAR
          = 
          dbo.SY40101.YEAR1
                   LEFT OUTER JOIN( 
                                    SELECT YEAR1 , 
                                           PERIODID , 
                                           PERNAME
                                      FROM dbo.SY40100
                                      GROUP BY YEAR1 , 
                                               PERIODID , 
                                               PERNAME
                                  )AS P
       ON dbo.GL20000.PERIODID
          = 
          P.PERIODID
      AND dbo.GL20000.OPENYEAR
          = 
          P.YEAR1
  WHERE dbo.GL00100.PSTNGTYP
        = 
        1
  ORDER BY AccountCategory , dbo.GL00105.ACTNUMST;