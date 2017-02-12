--Script to analyze and identify location codes that are assigned to items

SELECT * FROM IV00102 

WHERE

LOCNCODE like '0ON%' AND

(QTYONHND <> 0 OR

QTYONORD <> 0 OR

QTYINUSE <> 0 OR

--QTYALLOC <> 0 OR

QTYBKORD <>0 OR

QTYRTRND <> 0 OR

QTYINSVC <> 0 OR

QTYDMGED <> 0 )



DELETE FROM IV00102 WHERE

LOCNCODE = 'site id' AND

QTYONHND = 0 AND

QTYONORD = 0 AND

QTYINUSE = 0 AND

QTYALLOC = 0 AND

QTYBKORD =0 AND

QTYRTRND = 0 AND

QTYINSVC = 0 AND

QTYDMGED = 0

/*
Transaction records should also be removed from the Purchase Receipts table (IV10200). This can only be done by executing the following query statement. (Make sure to have a backup before executing this statement.)

 */

DELETE FROM IV10200 WHERE TRXLOCTN='site id'

/*
If multi-bin is in use, default bins may be assigned to the site to be deleted. If the site cannot be deleted after running the above scripts, all quantities are zero, and multi-site is enabled, run the following script in the query screen:
*/
 
UPDATE IV40700 SET

PORECEIPTBIN='',

PORETRNBIN='',

SOFULFILLMENTBIN='',

SORETURNBIN='',

BOMRCPTBIN='',

MATERIALISSUEBIN='',
MORECEIPTBIN='',

REPAIRISSUESBIN=''

WHERE LOCNCODE='site id'

 