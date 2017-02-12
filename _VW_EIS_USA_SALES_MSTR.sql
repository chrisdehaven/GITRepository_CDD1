
--SALES BY CATEGORY
SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         dbo.vw_EIS_USA_PD_TOTALS.PD AS USPD, 
                         dbo.vw_EIS_USA_PTD_SALES.PTD AS USPTD, 
                         dbo.vw_EIS_USA_PY_SALES.PY AS USPY, 
                         dbo.vw_EIS_USA_PY_SALES.ReportCat, 
                         dbo.vw_EIS_USA_PD_TOTALS.ReptSection, 
                         1 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  WHERE dbo.vw_EIS_USA_PD_TOTALS.ReptSection
        =
        'SALES'
UNION ALL
--GROSS SALES
SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         SUM (dbo.vw_EIS_USA_PD_TOTALS.PD) AS USPD, 
                         SUM (dbo.vw_EIS_USA_PTD_SALES.PTD) AS USPTD, 
                         SUM (dbo.vw_EIS_USA_PY_SALES.PY) AS USPY, 
                         'Gross Sales' AS ReportCat, 
                         dbo.vw_EIS_USA_PTD_SALES.ReptSection, 
                         2 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  GROUP BY SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2) +'/'+
SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) , 
           dbo.vw_EIS_USA_PTD_SALES.ReptSection
  HAVING dbo.vw_EIS_USA_PTD_SALES.ReptSection
         =
         'sales'
UNION ALL
--RETURNS, FREIGHT, DISCOUNTS

SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         dbo.vw_EIS_USA_PD_TOTALS.PD AS USPD, 
                         dbo.vw_EIS_USA_PTD_SALES.PTD AS USPTD, 
                         dbo.vw_EIS_USA_PY_SALES.PY AS USPY, 
                         dbo.vw_EIS_USA_PY_SALES.ReportCat, 
                         dbo.vw_EIS_USA_PD_TOTALS.ReptSection, 
                         3 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  WHERE dbo.vw_EIS_USA_PD_TOTALS.ReptSection
        =
        'less'
UNION ALL

--NET SALES

SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         SUM (dbo.vw_EIS_USA_PD_TOTALS.PD) AS USPD, 
                         SUM (dbo.vw_EIS_USA_PTD_SALES.PTD) AS USPTD, 
                         SUM (dbo.vw_EIS_USA_PY_SALES.PY) AS USPY, 
                         'Net Sales' AS ReportCat, 
                         'Net_Sales' AS ReptSection, 
                         4 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  WHERE dbo.vw_EIS_USA_PTD_SALES.ReptSection
        <>
        'COGS'
  GROUP BY SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2) +'/'+
SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) 
UNION ALL
--COGS

SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         SUM (dbo.vw_EIS_USA_PD_TOTALS.PD) AS USPD, 
                         SUM (dbo.vw_EIS_USA_PTD_SALES.PTD) AS USPTD, 
                         SUM (dbo.vw_EIS_USA_PY_SALES.PY) AS USPY, 
                         'LESS' AS ReportCat, 
                         'COGS' AS ReptSection, 
                         5 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  WHERE dbo.vw_EIS_USA_PTD_SALES.ReptSection
        =
        'COGS'
  GROUP BY SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2) +'/'+
SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) 
UNION ALL
--GROSS PROFIT

SELECT TOP (100) PERCENT SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2)
+'/'+SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) AS US_PD_DT, 
                         SUM (dbo.vw_EIS_USA_PD_TOTALS.PD) AS USPD, 
                         SUM (dbo.vw_EIS_USA_PTD_SALES.PTD) AS USPTD, 
                         SUM (dbo.vw_EIS_USA_PY_SALES.PY) AS USPY, 
                         'BottomLine' AS ReportCat, 
                         'Gross Profit' AS ReptSection, 
                         6 AS SECTIONKEY
  FROM
       dbo.vw_EIS_USA_PTD_SALES RIGHT OUTER JOIN dbo.vw_EIS_USA_PD_TOTALS
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PD_TOTALS.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PD_TOTALS.SortKey
                                FULL OUTER JOIN dbo.vw_EIS_USA_PY_SALES
       ON dbo.vw_EIS_USA_PTD_SALES.ReportCat
          =
          dbo.vw_EIS_USA_PY_SALES.ReportCat
      AND dbo.vw_EIS_USA_PTD_SALES.SortKey
          =
          dbo.vw_EIS_USA_PY_SALES.SortKey
  GROUP BY SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 5, 2) +'/'+
SUBSTRING (dbo.vw_EIS_USA_PD_TOTALS.[PD-DT], 7, 2) ;

