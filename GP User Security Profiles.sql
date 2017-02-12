
use DYNAMICS
go


SELECT	S.USERID UserID, S.CMPANYID CompanyID,
	C.CMPNYNAM CompanyName, S.SecurityRoleID,
	coalesce(T.SECURITYTASKID,'') SecurityTaskID,
	coalesce(TM.SECURITYTASKNAME,'') SecurityTaskName,
	coalesce(TM.SECURITYTASKDESC,'') SecurityTaskDescription

FROM	SY10500 S   -- security assignment user role

LEFT OUTER JOIN
	SY01500 C   -- company master
	ON S.CMPANYID = C.CMPANYID

LEFT OUTER JOIN
	SY10600 T  -- tasks in roles
	ON S.SECURITYROLEID = T.SECURITYROLEID 

LEFT OUTER JOIN
	SY09000 TM  -- tasks master
	ON T.SECURITYTASKID = TM.SECURITYTASKID 
	
	where USERID='slopez' and s.CMPANYID =5