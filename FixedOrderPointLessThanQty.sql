SELECT TOP ( 100
           )PERCENT i2.LOCNCODE , 
                    LOP.ITEMNMBR , 
                    i.ITEMDESC , 
                    LOP.FXDORDRQTY , 
                    LOP.ORDRPNTQTY , 
                    LOP.MNMMORDRQTY , 
                    LOP.MXMMORDRQTY , 
                    LOP.ORDERMULTIPLE , 
                    LOP.AVALIABLE , 
                    LOP.PRCHSNGLDTM , 
                    LOP.MNFCTRNGFXDLDTM , 
                    i2.PRIMVNDR , 
                    i3.MINORQTY , 
                    i3.MAXORDQTY , 
                    i3.ORDERMULTIPLE AS Expr1 , 
                    i3.PLANNINGLEADTIME , 
                    i.PRCHSUOM
  FROM
       TPSPT.dbo.fl_tipp_LessThanOrderPoint AS LOP LEFT OUTER JOIN TPSPT.dbo.IV00101 AS i
       ON LOP.ITEMNMBR
          = 
          i.ITEMNMBR
                                                   LEFT OUTER JOIN TPSPT.dbo.IV00102 AS i2
       ON i.ITEMNMBR
          = 
          i2.ITEMNMBR
                                                   LEFT OUTER JOIN TPSPT.dbo.IV00103 AS i3
       ON i2.ITEMNMBR
          = 
          i3.ITEMNMBR
      AND i2.PRIMVNDR
          = 
          i3.VENDORID
  WHERE i2.LOCNCODE
        = 
        '0IN'
UNION ALL
SELECT TOP ( 100
           )PERCENT i2.LOCNCODE , 
                    LOP.ITEMNMBR , 
                    i.ITEMDESC , 
                    LOP.FXDORDRQTY , 
                    LOP.ORDRPNTQTY , 
                    LOP.MNMMORDRQTY , 
                    LOP.MXMMORDRQTY , 
                    LOP.ORDERMULTIPLE , 
                    LOP.AVALIABLE , 
                    LOP.PRCHSNGLDTM , 
                    LOP.MNFCTRNGFXDLDTM , 
                    i2.PRIMVNDR , 
                    i3.MINORQTY , 
                    i3.MAXORDQTY , 
                    i3.ORDERMULTIPLE AS Expr1 , 
                    i3.PLANNINGLEADTIME , 
                    i.PRCHSUOM
  FROM
       TPEUR.dbo.fl_LessThanOrderPoint AS LOP LEFT OUTER JOIN TPEUR.dbo.IV00101 AS i
       ON LOP.ITEMNMBR
          = 
          i.ITEMNMBR
                                              LEFT OUTER JOIN TPEUR.dbo.IV00102 AS i2
       ON i.ITEMNMBR
          = 
          i2.ITEMNMBR
                                              LEFT OUTER JOIN TPEUR.dbo.IV00103 AS i3
       ON i2.ITEMNMBR
          = 
          i3.ITEMNMBR
      AND i2.PRIMVNDR
          = 
          i3.VENDORID
  WHERE i2.LOCNCODE
        = 
        '0EU'
  ORDER BY i2.LOCNCODE desc, i2.PRIMVNDR;