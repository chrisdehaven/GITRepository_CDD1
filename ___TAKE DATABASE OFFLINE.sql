select * from master.sys.sysprocesses
where spid>50 -- don't want system sessions
  and dbid = DB_ID('TPSPT')
  
use master
kill 472 -- the connection to the database in single user mode
use [TPSPT]
alter database [TPSPT] set multi_user with rollback immediate


kill 137
Kill 240
alter database [TPSPT] set multi_user with rollback immediate

Kill 420

-- Take the Database Offline
ALTER DATABASE [TPTST] SET OFFLINE WITH
ROLLBACK IMMEDIATE
GO
-- Take the Database Online
ALTER DATABASE [TPTST] SET ONLINE
GO