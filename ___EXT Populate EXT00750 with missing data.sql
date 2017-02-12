
 


INSERT  [TPTST].[dbo].[EXT00750]
       SELECT     Extender_Form_ID, UD_Form_Field_ID, LNITMSEQ
FROM         (SELECT     a.Extender_Form_ID, b.UD_Form_Field_ID, b.LNITMSEQ
                       FROM          dbo.EXT43100 AS a LEFT OUTER JOIN
                                              dbo.EXT00721 AS b ON a.Extender_Form_ID = b.Extender_Form_ID LEFT OUTER JOIN
                                              dbo.EXT00750 AS c ON b.Extender_Form_ID = c.Extender_Form_ID AND b.UD_Form_Field_ID = c.UD_Form_Field_ID AND 
                                              c.LNITMSEQ = b.LNITMSEQ
                       WHERE      (c.UD_Form_Field_ID IS NULL)) AS derivedtbl_1
GROUP BY Extender_Form_ID, UD_Form_Field_ID, LNITMSEQ
HAVING      (NOT (UD_Form_Field_ID IS NULL))