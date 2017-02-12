select s.SOPNUMBE, a.USERID,*
from tempdb.dbo.DEX_LOCK l
inner join DYNAMICS.dbo.ACTIVITY a
on l.session_id = a.SQLSESID
inner join SOP10100 s
on l.row_id = s.DEX_ROW_ID
and l.table_path_name = DB_NAME() + '.dbo.SOP10100'