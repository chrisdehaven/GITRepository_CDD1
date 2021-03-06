-- SET Database in SINGLE USER
-- Force DISCONNECT all connection
ALTER DATABASE TPTST
SET MULTI_USER 
WITH ROLLBACK AFTER 30

-- RESTORE Database 
RESTORE DATABASE [TPSPT] FROM  DISK = N'J:\SQL_BackupFiles\TPSPT\TPSPT_backup.bak' WITH  FILE = 1,  MOVE N'GPSTPSPTDat.mdf' TO N'F:\SQL_DataFiles\GPSTPTSTDat.mdf',  MOVE N'GPSTPSPTLog.ldf' TO N'G:\SQL_LogFiles\GPSTPTPTLog.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO

-- SET database in MULTI User Mode 
ALTER DATABASE SomeDB SET MULTI_USER
GO



RESTORE DATABASE [TPSPT] FROM  DISK = N'J:\SQL_BackupFiles\TPSPT\TPSPT_backup.bak' WITH  FILE = 1,  MOVE N'GPSTPSPTDat.mdf' TO N'F:\SQL_DataFiles\GPSTPTSTDat.mdf',  MOVE N'GPSTPSPTLog.ldf' TO N'G:\SQL_LogFiles\GPSTPTPTLog.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO

use master
alter database TPTST set offline with rollback immediate