USE [master]
GO
SELECT  session_id
 ,blocking_session_id
 ,wait_time
 ,wait_type
 ,last_wait_type
 ,wait_resource
 ,transaction_isolation_level
 ,lock_timeout
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0
GO



DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = (1134)
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
GO

SELECT
r.session_id,
s.TEXT,
r.[status],
r.blocking_session_id,
r.cpu_time,
r.total_elapsed_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s

SELECT * FROM sys.dm_exec_sessions
SELECT * FROM sys.dm_exec_sessions ORDER BY memory_usage DESC


select  * from sys.dm_tran_locks 


select es.session_id,es.memory_usage,sql_handle,(SELECT TOP 1    SUBSTRING(s2.text,statement_start_offset / 2+1 ,
( (CASE WHEN statement_end_offset = -1
THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2)
ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement 
FROM sys.dm_exec_sessions as es
INNER JOIN sys.dm_exec_requests as er ON er.session_id = es.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2


sys.dm_os_memory_clerks
select  memory_clerk_address,type,single_pages_kb,awe_allocated_kb
from  sys.dm_os_memory_clerks
--sys.dm_os_sys_info
select physical_memory_in_bytes,virtual_memory_in_bytes,bpool_commited,bpool_commited,bpool_commit_target from sys.dm_os_sys_info
--memory performance counters
--"\Memory\Available MBytes"
--"\Memory\Page Faults/sec"
--"\Memory\Pages/sec"
--"\Memory\Paging File(_Total)\%Usage"

select * from sys.dm_os_memory_clerks where type = 'MEMORYCLERK_SQLQERESERVATIONS'

SELECT * from . sys.dm_exec_query_memory_grants

select session_id, command,  status, sql_handlefrom 

select * from sys.dm_exec_requests


----------------

SELECT
db.name DBName,
tl.request_session_id,
wt.blocking_session_id,
OBJECT_NAME(p.OBJECT_ID) BlockedObjectName,
tl.resource_type,
h1.TEXT AS RequestingText,
h2.TEXT AS BlockingTest,
tl.request_mode
FROM sys.dm_tran_locks AS tl
INNER JOIN sys.databases db ON db.database_id = tl.resource_database_id
INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.partitions AS p ON p.hobt_id = tl.resource_associated_entity_id
INNER JOIN sys.dm_exec_connections ec1 ON ec1.session_id = tl.request_session_id
INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
GO