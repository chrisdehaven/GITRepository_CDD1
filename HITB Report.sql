SELECT
   ISNULL(X.[ITEMNMBR],Y.[ITEMNMBR]) [ITEMNMBR],
   X.HITB_Quantity_Available,
   X.HITB_Cost,
   Y.IV_Quantity_Available,
   Y.IV_EX_Cost,
   X.HITB_Cost - Y.IV_EX_Cost AS Cost_Variance
FROM
(
   SELECT  [ITEMNMBR],
   SUM([TRXQTYInBase]) HITB_Quantity_Available,
   SUM([EXTDCOST]) HITB_Cost
   FROM [SEE30303]
   GROUP BY [ITEMNMBR]
)   AS X    ------  Calculate the Extended_Cost per Item [SEE30303]

FULL OUTER JOIN   

(
   SELECT  [ITEMNMBR],
   SUM([QTYRECVD]-[QTYSOLD]) IV_Quantity_Available,
   SUM(([QTYRECVD]-[QTYSOLD])*[UNITCOST]) IV_EX_Cost
   FROM [IV10200]
   GROUP BY [ITEMNMBR]
)   AS Y    ------  Calculate the Extended_Cost per Item [IV10200]

ON X.[ITEMNMBR] = Y.[ITEMNMBR]
WHERE ABS( X.HITB_Cost - Y.IV_EX_Cost) > 1  OR
X.HITB_Quantity_Available<> Y.IV_Quantity_Available

 