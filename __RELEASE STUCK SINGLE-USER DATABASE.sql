Use Master

GO

Select * from master.sys.sysprocesses

Where spid > 50

            And dbid=DB_ID ('YOURDB')  -- replace with your database name

--Once you identified the spid to KILL, you can simply execute:

KILL xxxx 

--Then try to bring it back into multi-user role

ALTER DATABASE YOURDB SET MULTI_USER
GO

