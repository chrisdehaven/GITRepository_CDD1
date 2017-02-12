select * from master.sys.sysprocesses
where spid>50 -- don't want system sessions
  and dbid = DB_ID('TPTST')
  
use master
kill 472 -- the connection to the database in single user mode
use [TPTST]
alter database [TPTST] set multi_user with rollback immediate


kill 144
Kill 271
Kill 420

-- Take the Database Offline
ALTER DATABASE [TPTST] SET OFFLINE WITH
ROLLBACK IMMEDIATE
GO
-- Take the Database Online
ALTER DATABASE [TPTST] SET ONLINE
GO