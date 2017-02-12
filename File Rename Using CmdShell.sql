-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1;
GO
-- To update the currently configured value for advanced options.
RECONFIGURE;
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1;
GO
-- To update the currently configured value for this feature.
RECONFIGURE;
GO





Declare @dt datetime ,@SQLstmt varchar(100)

Set @dt=getdate()

set @SQLstmt ='RENAME \\web1\pdfs\D-EIS - Consolidated WW Report-'+convert(varchar(15),@dt,112)+'.pdf'

print @SQLstmt

exec xp_cmdshell @SQLstmt



