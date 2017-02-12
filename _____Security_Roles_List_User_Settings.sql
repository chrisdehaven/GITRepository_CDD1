
use DYNAMICS

SELECT S.USERID AS UserID, 
       S.CMPANYID AS CompanyID, 
       C.CMPNYNAM AS CompanyName, 
       S.SECURITYROLEID
  FROM
       dbo.SY10500 AS S LEFT OUTER JOIN dbo.SY01500 AS C
       ON S.CMPANYID
          =
          C.CMPANYID
                        LEFT OUTER JOIN dbo.SY10600 AS T
       ON S.SECURITYROLEID
          =
          T.SECURITYROLEID
                        LEFT OUTER JOIN dbo.SY09000 AS TM
       ON T.SECURITYTASKID
          =
          TM.SECURITYTASKID
  GROUP BY S.USERID, 
           S.CMPANYID, 
           C.CMPNYNAM, 
           S.SECURITYROLEID
  HAVING S.USERID
         in('lmann')
         and S.CMPANYID in(5)
         order by SECURITYROLEID
     