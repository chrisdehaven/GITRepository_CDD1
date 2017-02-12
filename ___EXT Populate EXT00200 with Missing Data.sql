INSERT TPTST.dbo.EXT00200
SELECT *
  FROM( 
        SELECT a.Extender_Form_ID , 
               b.UD_Form_Field_ID , 
               '' AS Expr1 , 
               '2009-12-21 00:00:00.000' AS Expr2 , 
               '' AS Expr3 , 
               '' AS Expr4 , 
               '2009-12-21 00:00:00.000' AS Expr5 , 
               0 AS Expr6
          FROM
               dbo.EXT40300 AS a LEFT OUTER JOIN dbo.EXT00201 AS b
               ON a.Extender_Form_ID
                  = 
                  b.Extender_Form_ID
                                 LEFT OUTER JOIN dbo.EXT00200 AS c
               ON b.Extender_Form_ID
                  = 
                  c.Extender_Form_ID
              AND b.UD_Form_Field_ID
                  = 
                  c.UD_Form_Field_ID
          WHERE c.UD_Form_Field_ID IS NULL
      )AS derivedtbl_1
  GROUP BY Extender_Form_ID , 
           UD_Form_Field_ID , 
           Expr1 , 
           Expr2 , 
           Expr3 , 
           Expr4 , 
           Expr5 , 
           Expr6
  HAVING NOT UD_Form_Field_ID IS NULL;