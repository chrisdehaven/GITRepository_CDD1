--prior to setting up an item for Lot Tracking the item needs to have all pending activity cleared
--this script identifies where the item is in use.

DECLARE @value VARCHAR(64)

DECLARE @sql VARCHAR(1024)

DECLARE @table VARCHAR(64)

DECLARE @column VARCHAR(64)

SET @value = 'T101042'

CREATE TABLE #t (

   tablename VARCHAR(64),

   columnname VARCHAR(64)

)

DECLARE TABLES CURSOR

FOR

   SELECT o.name, c.name

   FROM syscolumns c

   INNER JOIN sysobjects o ON c.id = o.id

   WHERE o.type = 'U' AND c.xtype IN (167, 175, 231, 239)

   ORDER BY o.name, c.name

OPEN TABLES

FETCH NEXT FROM TABLES

INTO @table, @column

WHILE @@FETCH_STATUS = 0

BEGIN

   SET @sql = 'IF EXISTS(SELECT NULL FROM [' + @table + '] '

   --SET @sql = @sql + 'WHERE RTRIM(LTRIM([' + @column + '])) = ''' + @value + ''') '

   SET @sql = @sql + 'WHERE RTRIM(LTRIM([' + @column + '])) LIKE ''%' + @value + '%'') '

   SET @sql = @sql + 'INSERT INTO #t VALUES (''' + @table + ''', '''

   SET @sql = @sql + @column + ''')'

   EXEC(@sql)

   FETCH NEXT FROM TABLES

   INTO @table, @column

END

CLOSE TABLES

DEALLOCATE TABLES

SELECT *

FROM #t

DROP TABLE #t


