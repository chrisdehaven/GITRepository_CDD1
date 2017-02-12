/*
Deleting a Site

The information below is taken from Confessions of a Dynamics GP Consultant.

 

When a site is created, a record is added to the Site Table (IV40700). Records are then added as needed to other tables. Before a Site can be deleted properly, all the associated records must be deleted. This includes:

Item Quantity/Site Records IV00102

Item Site/Bin Master IV00112

Item Purchase Receipts IV10200

Make sure to post all transactions and batches involving inventory before starting this process. This includes sales batches, purchasing batches, manufacturing batches, as well as inventory transaction batches. Not posting these batches before deleting the site may result in unpostable batches.

The Item Quantity Site Table (IV00102) holds a number of counts related to items for each site. Look at the Item Inquiry screen (Inquiry->Inventory->Item) to see the type of information stored in this table. All of these counts must be zero before the Item Quantity / Site record is deleted for a site. 

Quantities on Hand must be transferred to another site using the Item Transfer Entry screen (Transactions->Inventory->Transfer Entry) or otherwise adjusted to zero using the Item Transaction Entry screen (Transactions->Inventory->Transaction Entry). Make sure that all transactions entered are posted. If there are any quantities In Use, In Service, or Damaged, these quantities must be moved to On Hand and then adjusted out as described above.

Quantities Allocated represent quantities on Sales Order Processing Orders, un-posted Invoices, or Fulfillment Orders. These documents must be located and the items removed before the site records can be deleted. If manufacturing is in use, the Allocated Quantity may also include components on Manufacturing Picklists.

On Order quantities represent quantities listed on Purchase Orders or as parent items on Manufacturing Orders (MO). Again, these documents must be located and the items removed from the PO, the line canceled, or the PO fully received and closed before the site can be deleted. If MOs exist to build the item, they must be deleted or completed and closed.

Once all quantities are properly zeroed out, the sites must be removed from the items. This is performed through the software by opening the Item Quantity Maintenance screen, entering the item number, selecting the site and hitting the Delete button. Unfortunately, this must be done for every inventory item that contains a quantity record for the site to be deleted. This can take considerable time.

The following Transact SQL commands can be executed in Query Analyzer to make the process easier. This first script will produce a list of the items that are assigned to the site that have quantities that need to be adjusted.

 */

use TPSPT

SELECT * FROM IV00102 

WHERE

LOCNCODE = '0ON' AND

(QTYONHND <> 0 OR

QTYONORD <> 0 OR

QTYINUSE <> 0 OR

ATYALLOC <> 0 OR

QTYBKORD <>0 OR

QTYRTRND <> 0 OR

QTYINSVC <> 0 OR

QTYDMGED <> 0 )

 
/*
Make sure to replace site id with the id of the site to be deleted.

Once the adjustments to the quantities have been made, the site quantity records can be deleted. As mentioned above, this can be done manually one record at a time. Alternately, the script below can be used to delete all record assignments at one time.

*/

DELETE FROM IV00102 WHERE

LOCNCODE = '0ON' AND

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

 /*

Note that site id must be replaced with the site id of the site to be deleted and '' represents two (2) single quotes and not one double quote.

At this point, the site can be deleted by opening the Site Maintenance screen (Cards->Inventory->Site), looking up the site, and clicking on the DELETE button. If the site will not delete, reexamine the issues above.

 */