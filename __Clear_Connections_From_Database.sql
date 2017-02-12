USE [master];
GO

DECLARE @DatabaseID SMALLINT = DB_ID(N'TPTST');    
DECLARE @SQL NVARCHAR(10);

WHILE EXISTS ( SELECT
                1
               FROM
                sys.dm_exec_sessions
               WHERE
                database_id = @DatabaseID )    
    BEGIN;
        SET @SQL = (
                    SELECT TOP 1
                        N'kill ' + CAST(session_id AS NVARCHAR(5)) + ';'
                    FROM
                        sys.dm_exec_sessions
                    WHERE
                        database_id = @DatabaseID
                   );
        EXEC sys.sp_executesql @SQL;
    END;