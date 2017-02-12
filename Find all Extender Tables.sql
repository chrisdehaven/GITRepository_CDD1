
-- Created by Mariano Gomez, MVP
-- Code is "AS IS". No warranties expressed or implied and conferes no rights
SELECT '/* ' + RTRIM(TABLE_NAME)
   + '*/ SELECT ''' + RTRIM(TABLE_NAME) + ''' AS Extender_Table, * FROM '
   + RTRIM(TABLE_NAME) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'EXT%'
