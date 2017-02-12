/*==============================================================================
Name:                   Kick a user out of a database

Description:            The script acccepts a user name and a database name
                        as the variables @LoginName and @DatabaseName, respectively,
                        and kills the user processes on that database.
                        The script also 2 additional parameters, namely
                        @NumberOfTimesToLoop and @TimeToCheckKillInSec
                        that are used as follows: After attempting to kill a process,
                        the script checks whether the process was indeed killed.
                        If not, the script loops for up to @NumberOfTimesToLoop
                        times and in each loop it waits for a duration (in seconds)
                        specified by the value @TimeToCheckKillInSec.
        
                        If the process is not killed after 
                        @TimeToCheckKillInSec x @NumberOfTimesToLoop [seconds]
                        (for example, due to a long running transaction rollback that
                        was invokved by the KILL command) then the script aborts
                        and notifies the user of this fact.

USER PARAMETERS:        @LoginName
                        @DatabaseName
                        @NumberOfTimesToLoop
                        @TimeToCheckKillInSec

RESULTSET:              NA

RESULTSET SORT:         NA

USING TABLES/VIEWS:     NA

REVISIONS

DATE         DEVELOPER          DESCRIPTION OF REVISION             VERSION
=========    ===============    =================================   ===========
04/12/2007   Omri Bahat         Initial release                     1.00
==================================================================================*/


SET NOCOUNT ON
                
DECLARE @LoginName SYSNAME
DECLARE @DatabaseName SYSNAME
DECLARE @NumberOfTimesToLoop INT
-- Time to wait between checks
-- should be between 1 to 599 seconds.
DECLARE @TimeToCheckKillInSec INT

SET @LoginName = 'sa'
SET @DatabaseName = 'master'
SET @NumberOfTimesToLoop = 2
SET @TimeToCheckKillInSec = 3


DECLARE @WaitTimeStr VARCHAR(8)
DECLARE @i INT
DECLARE @sCurrentSPIDToKill VARCHAR(32)
DECLARE @sSPID VARCHAR(32)
DECLARE @ServerVersion NVARCHAR(128)

SET @sSPID = CAST(@@SPID AS VARCHAR(32))

IF OBJECT_ID('tempdb..#utbSPWHO2', 'TABLE') IS NOT NULL
        DROP TABLE #utbSPWHO2

CREATE TABLE #utbSPWHO2 (
        SPID INT,
        [Status] NVARCHAR(128),
        LoginName NVARCHAR(128),
        HostName NVARCHAR(128),
        BlockedBy NVARCHAR(32),
        DBName NVARCHAR(128),
        Command NVARCHAR(128),
        CPUTime NVARCHAR(64),
        DiskIO NVARCHAR(64),
        LastBatchRunTime NVARCHAR(64),
        ProgramName NVARCHAR(512),
        SPID2 INT,
        RequestID INT)

-- The clustered index uses the
-- current @@SPID to make
-- sure that the index name
-- is unique.
EXEC('CREATE CLUSTERED INDEX
CI_#utbSPWHO2_' + @sSPID + '
ON #utbSPWHO2 (LoginName, DBName, SPID)')

-- sp_who2 is version-sensitive - RequestID is returned
-- for SQL 2K5 and later but not in SQL 2K.
SET @ServerVersion = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128))

-- Get the sp_who2 results.
IF @ServerVersion LIKE '8.%' OR @ServerVersion LIKE '7.%'
        INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2)
        EXEC sp_who2        
ELSE
        INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2, RequestID)
        EXEC sp_who2


IF NOT EXISTS(
        SELECT *
        FROM #utbSPWHO2
        WHERE LoginName = @LoginName
                AND DBName = @DatabaseName)
BEGIN
        PRINT('The user is not currently using the DB')
        RETURN
END

-- @WaitTimeStr is used in
-- a WAITFOR DELAY command later.
SET @WaitTimeStr = '00:0' + CAST(@TimeToCheckKillInSec/60 AS CHAR(1))
        + CASE WHEN (@TimeToCheckKillInSec%60) < 10
               THEN ':0'
               ELSE ':'
          END
        + CAST(@TimeToCheckKillInSec%60 AS VARCHAR(2))

-- Get the first SPID to kill.
-- HostName is checked as well
-- to make sure we don't kill
-- internal machine processes.
SELECT @sCurrentSPIDToKill = CAST(MIN(SPID) AS VARCHAR(32))
FROM #utbSPWHO2
WHERE LoginName = @LoginName
        AND DBName = @DatabaseName
        AND RTRIM(LTRIM(HostName)) <> N'.'
        AND SPID <> @@SPID

WHILE @sCurrentSPIDToKill IS NOT NULL
BEGIN
        -- Launch the KILL command.
        EXEC('KILL ' + @sCurrentSPIDToKill)
        
        -- Check if the process was killed
        TRUNCATE TABLE #utbSPWHO2
        
        IF @ServerVersion LIKE '8.%' OR @ServerVersion LIKE '7.%'
                INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2)
                EXEC sp_who2        
        ELSE
                INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2, RequestID)
                EXEC sp_who2

        
        SET @i = 1

        WHILE EXISTS(
        SELECT *
        FROM #utbSPWHO2
        WHERE LoginName = @LoginName
                AND DBName = @DatabaseName
                AND SPID = CAST(@sCurrentSPIDToKill AS INT))

        AND @i <= @NumberOfTimesToLoop

        BEGIN
                -- Wait and check if the
                -- process was killed again.
                WAITFOR DELAY @WaitTimeStr
                
                -- Check if the process was killed
                TRUNCATE TABLE #utbSPWHO2
                
                IF @ServerVersion LIKE '8.%' OR @ServerVersion LIKE '7.%'
                        INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2)
                        EXEC sp_who2        
                ELSE
                        INSERT INTO #utbSPWHO2 (SPID, [Status], LoginName, HostName, BlockedBy, DBName, Command, CPUTime, DiskIO, LastBatchRunTime, ProgramName, SPID2, RequestID)
                        EXEC sp_who2
                

                SET @i = @i + 1
        END

        -- Check if loop exited
        -- because process was killed
        -- or due to too many loop.
        IF @i > @NumberOfTimesToLoop
        BEGIN
                -- Too many loop.
                -- Abort and notify the user.
                RAISERROR('The script could not kill process id = %s.', 16, 1, @sCurrentSPIDToKill)
                RETURN
        END
        ELSE
                PRINT('Process id ' + @sCurrentSPIDToKill + ' was killed successfully')

        -- If we got this far then
        -- the process was killed
        -- and we need to find the
        -- next process to kill.
        SET @sCurrentSPIDToKill = NULL

        SELECT @sCurrentSPIDToKill = CAST(MIN(SPID) AS VARCHAR(32))
        FROM #utbSPWHO2
        WHERE LoginName = @LoginName
                AND DBName = @DatabaseName
                AND RTRIM(LTRIM(HostName)) <> N'.'
                AND SPID <> @@SPID
END


