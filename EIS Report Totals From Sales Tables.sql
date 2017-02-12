SELECT SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='199' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PTD Markers], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='199' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PD MARKERS], 
       SUM (CASE
            WHEN 
              MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx='199' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PY MARKERS], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx IN ('201', '200') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PD ACCESSORIES], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx IN ('201', '200') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PTD Accessories], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx IN ('201', '200') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PY ACCESSORIES], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='202' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PD APPAREL], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='202' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PTD Apparel], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx='202' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PY APPAREL], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='926' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PD LASER TAG], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='926' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PTD Laser Tag], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx='926' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PY LASER TAG], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='1028' THEN CASE SD.SOPTYPE
                                     WHEN 3 THEN SD.XTNDPRCE
                                     WHEN 4 THEN SD.XTNDPRCE*-1
                                     END
                ELSE 0
            END) AS [PD CAMPING], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='1028' THEN CASE SD.SOPTYPE
                                     WHEN 3 THEN SD.XTNDPRCE
                                     WHEN 4 THEN SD.XTNDPRCE*-1
                                     END
                ELSE 0
            END) AS [PTD Camping], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx='1028' THEN CASE SD.SOPTYPE
                                     WHEN 3 THEN SD.XTNDPRCE
                                     WHEN 4 THEN SD.XTNDPRCE*-1
                                     END
                ELSE 0
            END) AS [PY CAMPING], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='647' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PD LTL], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx='647' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PTD LTL], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx='647' THEN CASE SD.SOPTYPE
                                    WHEN 3 THEN SD.XTNDPRCE
                                    WHEN 4 THEN SD.XTNDPRCE*-1
                                    END
                ELSE 0
            END) AS [PY LTL], 
       SUM (CASE
            WHEN DAY (SH.DOCDATE)
                 =
                 DAY (GETDATE ()) -1
             AND MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx IN ('203', '639') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PD OTHER], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ())
             AND slsindx IN ('203', '639') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PTD Other], 
       SUM (CASE
            WHEN MONTH (SH.DOCDATE)
                 =
                 MONTH (GETDATE ())
             AND YEAR (SH.DOCDATE)
                 =
                 YEAR (GETDATE ()) -1
             AND slsindx IN ('203', '639') THEN CASE SD.SOPTYPE
                                                WHEN 3 THEN SD.XTNDPRCE
                                                WHEN 4 THEN SD.XTNDPRCE*-1
                                                END
                ELSE 0
            END) AS [PY OTHER]
  FROM
       dbo.SOP30200 AS SH INNER JOIN dbo.SOP30300 AS SD
       ON SD.SOPNUMBE
          =
          SH.SOPNUMBE
      AND SD.SOPTYPE
          =
          SH.SOPTYPE
  WHERE SH.VOIDSTTS=0
    AND SH.SOPTYPE IN (3, 4)
    AND SD.XTNDPRCE<>0
    AND SH.PSTGSTUS=2;