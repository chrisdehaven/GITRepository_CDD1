/*****************************************************************************************
NAME: Create Shadow Table Automatically.sql

DESCRIPTION:
	This script prints scripts that can be run against a company database to create
	a shadow table to a current database table. Three triggers are applied to the 
	defined table (insert, update, and delete) to insert information into the 
	shadow table upon those events.
	
	Please use this script with caution!


INSTRUCTIONS:
	1. Make a full backup of the company database.
	2. Enter in the indicated place table for which you want to track information.
	3. Enter the option desired for the @Output variable:
	
			0 = Print a script that removes any current table/triggers, and creates new
			1 = Execute a script that removes current, and creates new
			2 = Print a script that removes current table/triggers
			3 = Execute a script that removes current table/triggers

CREATED DATE: 09/06/2005

LAST UPDATED: 2013 - Ken Hubbard - Added SQL text column

*****************************************************************************************/

DECLARE
   @TableName varchar(255) , 
   @Output    tinyint;
SET @TableName = 'PM30200';     

/* Replace with table to be shadowed	*/

SET @Output = 0;

DECLARE
   @dropsql       varchar(8000) , 
   @presql        varchar(8000) , 
   @sql           varchar(8000) , 
   @postsql       varchar(8000) , 
   @allcolumnssql varchar(8000) , 
   @ColumnName    varchar(255) , 
   @ColumnType    varchar(100) , 
   @ColumnLength  int , 
   @ColumnPrec    int , 
   @ColumnScale   int , 
   @go            varchar(4);

SET @go = ' go '; 

/*****START - BUILD SHADOW TABLE*****/

IF EXISTS( SELECT c.name
             FROM
                  sysobjects a INNER JOIN
                               syscolumns b
             ON a.id = b.id
                               INNER JOIN
                               systypes c
             ON b.usertype
                = 
                c.usertype
            AND b.type = c.type
            AND b.xtype
                = 
                c.xtype
             WHERE a.type = 'U'
               AND a.name
                   = 
                   @TableName
               AND c.name NOT IN( 'numeric' , 'char' , 'varchar' , 'binary' , 'datetime' , 'bigint' , 'int' , 'smallint' , 'tinyint'
                                )
         )
    BEGIN
        PRINT 'ERROR - Column with Datatype that is not tested has been found.';
        RETURN;
    END;

DECLARE T_cursor CURSOR
    FOR SELECT a.name , 
               b.name , 
               c.name , 
               CASE
               WHEN c.name IN( 'char' , 'varchar' , 'binary'
                             ) THEN b.length
                   ELSE 0
               END AS length , 
               CASE
               WHEN c.name
                    = 
                    'numeric' THEN b.prec
                   ELSE 0
               END AS prec , 
               CASE
               WHEN c.name
                    = 
                    'numeric' THEN b.scale
                   ELSE 0
               END AS scale
          FROM
               sysobjects a INNER JOIN
                            syscolumns b
          ON a.id = b.id
                            INNER JOIN
                            systypes c
          ON b.usertype
             = 
             c.usertype
         AND b.type = c.type
         AND b.xtype
             = 
             c.xtype
          WHERE a.type = 'U'
            AND a.name
                = 
                @TableName
          ORDER BY b.colid;


SET @dropsql = 'IF EXISTS (SELECT name FROM sysobjects WHERE  name = N''' + @TableName + 'CaptureShadow'' AND type = ''U'')
    DROP TABLE ' + @TableName + 'CaptureShadow';
IF @Output IN( 0 , 2
             )
    BEGIN
        PRINT @dropsql;
        PRINT @go;
    END;
IF @Output IN( 1 , 3
             )
    BEGIN EXEC ( @dropsql
               );
    END;

SET @presql = 'create table ' + @TableName + 'CaptureShadow (' + CHAR(13);
SET @sql = '';
SET @allcolumnssql = '';

OPEN T_cursor;
FETCH NEXT FROM T_cursor INTO
   @TableName , 
   @ColumnName , 
   @ColumnType , 
   @ColumnLength , 
   @ColumnPrec , 
   @ColumnScale;
WHILE @@fetch_status
      <> 
      -1
    BEGIN
        SET @sql = @sql + @ColumnName + ' ' + @ColumnType + ' ' + CASE
                                                                  WHEN @ColumnLength
                                                                       = 
                                                                       0 THEN ''
                                                                      ELSE '(' + CAST(@ColumnLength AS varchar(10)) + ')'
                                                                  END + CASE
                                                                        WHEN @ColumnPrec = 0
                                                                         AND @ColumnScale = 0 THEN ''
                                                                            ELSE '(' + CAST(@ColumnPrec AS varchar(10)) + ',' + CAST(@ColumnScale AS varchar(10)) + ')'
                                                                        END + ',' + CHAR(13);

        /*Variable used later for building Triggers*/

        SET @allcolumnssql = @allcolumnssql + @ColumnName + ',' + CHAR(13);

        FETCH NEXT FROM T_cursor INTO
           @TableName , 
           @ColumnName , 
           @ColumnType , 
           @ColumnLength , 
           @ColumnPrec , 
           @ColumnScale;
    END;
CLOSE T_cursor;
DEALLOCATE T_cursor;

SET @postsql = 'CapturedProcess varchar(20), ' + CHAR(13);
SET @postsql = @postsql + 'CapturedSPID int,' + CHAR(13);
SET @postsql = @postsql + 'CapturedLoginID varchar(255),' + CHAR(13);
SET @Postsql = @postsql + 'CapturedTimeStamp datetime,' + CHAR(13);
SET @Postsql = @postsql + 'SQLText nvarchar(max),' + CHAR(13);
SET @Postsql = @postsql + 'CapturedIndentityColumn int IDENTITY(1, 1)';
SET @Postsql = @Postsql + ')';

SET @sql = @presql + @sql + @postsql;
IF @Output = 0
    BEGIN
        PRINT @sql;
        PRINT @go;
    END;
IF @Output = 1
    BEGIN EXEC ( @sql
               );
    END;

/*****END - BUILD SHADOW TABLE*****/



/*****START - BUILD INSERT TRIGGER*****/

SET @dropsql = 'IF EXISTS (SELECT name FROM sysobjects WHERE name = N''' + @TableName + 'CaptureShadowInsertTrigger'' AND type = ''TR'')
    DROP TRIGGER ' + @TableName + 'CaptureShadowInsertTrigger';
IF @Output IN( 0 , 2
             )
    BEGIN
        PRINT @dropsql;
        PRINT @go;
    END;
IF @Output IN( 1 , 3
             )
    BEGIN EXEC ( @dropsql
               );
    END;

SET @sql = 'CREATE TRIGGER ' + @TableName + 'CaptureShadowInsertTrigger on ' + @TableName + ' FOR INSERT AS' + CHAR(13);
SET @sql = @sql + 'set nocount on' + CHAR(13);
SET @sql = @sql + 'declare @sqlbuffer table (EVENTTYPE nvarchar(30), PARAMETERS int, EVENTINFO nvarchar(max))' + CHAR(13);
SET @sql = @sql + 'declare @i_sql varchar(8000)' + CHAR(13);
SET @sql = @sql + 'declare @cmd varchar(8000)' + CHAR(13);
SET @sql = @sql + 'select @cmd = ''DBCC INPUTBUFFER(''+ convert(varchar,@@spid) +'')''' + CHAR(13);
SET @sql = @sql + 'insert into @sqlbuffer exec (@cmd)' + CHAR(13);
SET @sql = @sql + 'insert into ' + @TableName + 'CaptureShadow (' + @allcolumnssql + ' CapturedProcess,' + CHAR(13) + 'CapturedSPID,' + CHAR(13) + 'CapturedLoginID,' + CHAR(13) + 'CapturedTimeStamp,' + CHAR(13) + 'SQLText)' + CHAR(13);
SET @sql = @sql + 'select ' + @allcolumnssql + ' ''INSERT'', @@SPID, SUSER_NAME(), getdate(), (select EVENTINFO from @sqlbuffer) from inserted';
IF @Output = 0
    BEGIN
        PRINT @sql;
        PRINT @go;
    END;
IF @Output = 1
    BEGIN EXEC ( @sql
               );
    END;

/*****END - BUILD INSERT TRIGGER*****/



/*****START - BUILD DELETE TRIGGER*****/

SET @dropsql = 'IF EXISTS (SELECT name FROM sysobjects WHERE name = N''' + @TableName + 'CaptureShadowDeleteTrigger'' AND type = ''TR'')
    DROP TRIGGER ' + @TableName + 'CaptureShadowDeleteTrigger';
IF @Output IN( 0 , 2
             )
    BEGIN
        PRINT @dropsql;
        PRINT @go;
    END;
IF @Output IN( 1 , 3
             )
    BEGIN EXEC ( @dropsql
               );
    END;

SET @sql = 'CREATE TRIGGER ' + @TableName + 'CaptureShadowDeleteTrigger on ' + @TableName + ' FOR DELETE AS' + CHAR(13);
SET @sql = @sql + 'set nocount on' + CHAR(13);
SET @sql = @sql + 'declare @sqlbuffer table (EVENTTYPE nvarchar(30), PARAMETERS int, EVENTINFO nvarchar(max))' + CHAR(13);
SET @sql = @sql + 'declare @i_sql varchar(8000)' + CHAR(13);
SET @sql = @sql + 'declare @cmd varchar(8000)' + CHAR(13);
SET @sql = @sql + 'select @cmd = ''DBCC INPUTBUFFER(''+ convert(varchar,@@spid) +'')''' + CHAR(13);
SET @sql = @sql + 'insert into @sqlbuffer exec (@cmd)' + CHAR(13);
SET @sql = @sql + 'insert into ' + @TableName + 'CaptureShadow (' + @allcolumnssql + ' CapturedProcess,' + CHAR(13) + 'CapturedSPID,' + CHAR(13) + 'CapturedLoginID,' + CHAR(13) + 'CapturedTimeStamp,' + CHAR(13) + 'SQLText)' + CHAR(13);
SET @sql = @sql + 'select ' + @allcolumnssql + ' ''DELETE'', @@SPID, SUSER_NAME(), getdate(), (select EVENTINFO from @sqlbuffer) from deleted';
IF @Output = 0
    BEGIN
        PRINT @sql;
        PRINT @go;
    END;
IF @Output = 1
    BEGIN EXEC ( @sql
               );
    END;

/*****END - BUILD DELETE TRIGGER*****/



/*****START - BUILD UPDATE TRIGGER*****/

SET @dropsql = 'IF EXISTS (SELECT name FROM sysobjects WHERE name = N''' + @TableName + 'CaptureShadowUpdateTrigger'' AND type = ''TR'')
    DROP TRIGGER ' + @TableName + 'CaptureShadowUpdateTrigger';
IF @Output IN( 0 , 2
             )
    BEGIN
        PRINT @dropsql;
        PRINT @go;
    END;
IF @Output IN( 1 , 3
             )
    BEGIN EXEC ( @dropsql
               );
    END;

SET @sql = 'CREATE TRIGGER ' + @TableName + 'CaptureShadowUpdateTrigger on ' + @TableName + ' FOR UPDATE AS' + CHAR(13);
SET @sql = @sql + 'set nocount on' + CHAR(13);
SET @sql = @sql + 'declare @sqlbuffer table (EVENTTYPE nvarchar(30), PARAMETERS int, EVENTINFO nvarchar(max))' + CHAR(13);
SET @sql = @sql + 'declare @i_sql varchar(8000)' + CHAR(13);
SET @sql = @sql + 'declare @cmd varchar(8000)' + CHAR(13);
SET @sql = @sql + 'select @cmd = ''DBCC INPUTBUFFER(''+ convert(varchar,@@spid) +'')''' + CHAR(13);
SET @sql = @sql + 'insert into @sqlbuffer exec (@cmd)' + CHAR(13);
SET @sql = @sql + 'insert into ' + @TableName + 'CaptureShadow (' + @allcolumnssql + ' CapturedProcess,' + CHAR(13) + 'CapturedSPID,' + CHAR(13) + 'CapturedLoginID,' + CHAR(13) + 'CapturedTimeStamp,' + CHAR(13) + 'SQLText)' + CHAR(13);
SET @sql = @sql + 'select ' + @allcolumnssql + ' ''UPDATEOLD'', @@SPID, SUSER_NAME(), getdate(), (select EVENTINFO from @sqlbuffer) from deleted' + CHAR(13);

SET @sql = @sql + 'insert into ' + @TableName + 'CaptureShadow (' + @allcolumnssql + ' CapturedProcess,' + CHAR(13) + 'CapturedSPID,' + CHAR(13) + 'CapturedLoginID,' + CHAR(13) + 'CapturedTimeStamp,' + CHAR(13) + 'SQLText)' + CHAR(13);
SET @sql = @sql + 'select ' + @allcolumnssql + ' ''UPDATENEW'', @@SPID, SUSER_NAME(), getdate(), (select EVENTINFO from @sqlbuffer) from inserted';
IF @Output = 0
    BEGIN
        PRINT @sql;
        PRINT @go;
    END;
IF @Output = 1
    BEGIN EXEC ( @sql
               );
    END;

    /*****END - BUILD UPDATE TRIGGER*****/