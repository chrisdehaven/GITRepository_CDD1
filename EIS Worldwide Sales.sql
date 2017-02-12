SELECT TOP ( 100
           ) PERCENT dbo.Location_XLT.COMPANY , 
                     dbo.Location_XLT.SITE AS Location , 
                     d.DESCR AS [Sales Category] , 
                     d.SortKey , 
                     SUM(ISNULL(CASE
                                WHEN CONVERT( varchar(10) , [document date] , 110)
                                     = 
                                     CONVERT(varchar(10) , GETDATE() - 1 , 110) THEN CASE
                                                                                     WHEN [sop type]
                                                                                          = 
                                                                                          'return' THEN [extended price] * -1
                                                                                         ELSE [extended price]
                                                                                     END
                                END , 0)) AS PD , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE())
                                 AND MONTH([document date])
                                     = 
                                     MONTH(GETDATE()) THEN CASE
                                                           WHEN [sop type]
                                                                = 
                                                                'return' THEN [extended price] * -1
                                                               ELSE [extended price]
                                                           END
                                END , 0)) AS PTD , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE()) THEN CASE
                                                          WHEN [sop type]
                                                               = 
                                                               'return' THEN [extended price] * -1
                                                              ELSE [extended price]
                                                          END
                                END , 0)) AS YTD , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE()) - 1
                                 AND MONTH([document date])
                                     <= 
                                     MONTH(GETDATE()) THEN CASE
                                                           WHEN [sop type]
                                                                = 
                                                                'return' THEN [extended price] * -1
                                                               ELSE [extended price]
                                                           END
                                END , 0)) AS PYTD , 
                     SUM(ISNULL(CASE
                                WHEN CONVERT( varchar(10) , [document date] , 110)
                                     = 
                                     CONVERT(varchar(10) , GETDATE() - 1 , 110) THEN CASE
                                                                                     WHEN [sop type]
                                                                                          = 
                                                                                          'return' THEN [extended cost] * -1
                                                                                         ELSE [extended cost]
                                                                                     END
                                END , 0)) AS PDCost , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE())
                                 AND MONTH([document date])
                                     = 
                                     MONTH(GETDATE()) THEN CASE
                                                           WHEN [sop type]
                                                                = 
                                                                'return' THEN [extended cost] * -1
                                                               ELSE [extended cost]
                                                           END
                                END , 0)) AS PTDCost , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE()) THEN CASE
                                                          WHEN [sop type]
                                                               = 
                                                               'return' THEN [extended cost] * -1
                                                              ELSE [extended cost]
                                                          END
                                END , 0)) AS YTDCost , 
                     SUM(ISNULL(CASE
                                WHEN CONVERT( varchar(10) , [document date] , 110)
                                     = 
                                     CONVERT(varchar(10) , GETDATE() - 1 , 110) THEN CASE
                                                                                     WHEN [sop type]
                                                                                          = 
                                                                                          'return' THEN qty * -1
                                                                                         ELSE qty
                                                                                     END
                                END , 0)) AS PDQty , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE())
                                 AND MONTH([document date])
                                     = 
                                     MONTH(GETDATE()) THEN CASE
                                                           WHEN [sop type]
                                                                = 
                                                                'return' THEN qty * -1
                                                               ELSE qty
                                                           END
                                END , 0)) AS PTDQty , 
                     SUM(ISNULL(CASE
                                WHEN YEAR([document date])
                                     = 
                                     YEAR(GETDATE()) THEN CASE
                                                          WHEN [sop type]
                                                               = 
                                                               'return' THEN qty * -1
                                                              ELSE qty
                                                          END
                                END , 0)) AS YTDQty
  FROM
       dbo._SALESHISTORY AS sh INNER JOIN
                                dbo.Location_XLT
  ON sh.[location code]
     = 
     dbo.Location_XLT.LOCNCODE
                                INNER JOIN
                                dbo.IV40400_Item_Class_Descriptions AS d
  ON sh.[item class code]
     = 
     d.ITMCLSCD
  WHERE sh.[posting status] 
        = 
        'Posted'
        
    and [document date] > '3/31/2015'
        
  -- AND NOT sh.[customer number] IN( 'ZZZTSEU' , 'GIS-INTR003' , 'GISP002')
  GROUP BY d.DESCR , 
           d.SortKey , 
           dbo.Location_XLT.SITE , 
           dbo.Location_XLT.COMPANY
  ORDER BY dbo.Location_XLT.COMPANY , Location , d.SortKey;