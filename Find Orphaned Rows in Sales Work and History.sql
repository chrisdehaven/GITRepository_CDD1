--// Display abandoned rows from the SALES ORDER table -- as candidate for deletion.
--// They are dependent line item rows that do not have a corresponding
--// master entry and therefore are considered "garbage data".
--// This query will display the unique row id of each abandoned
--// record, along with the Document Number and Document Type.
--// Since these abandoned rows have no use, you can safely delete them.
--// Be careful when deleting rows, always validate against unique ROW ID
select D.DEX_ROW_ID, D.SOPNUMBE, D.SOPTYPE from sop30300 D
where D.sopnumbe not in
(
select M.sopnumbe from sop30200 M
)

--// The script below displays the orphaned entries from
--// the WORKORDER TABLE. This too should be well maintained
--// because all order items go through this table.
select D.DEX_ROW_ID, D.SOPNUMBE, D.SOPTYPE from sop10200 D
where D.sopnumbe not in
(
select M.sopnumbe from sop10100 M
)

--// After you have identified the orphaned rows, 
--// use this command to delete them.
--// Note that we used 3 columns for validation. Technically, 
--// just the DEX_ROW_ID is enough to delete the row we want but
--// we wanted to make sure we delete the right row that we really intended
--// to delete; hence, the additional validation for SOPNUMBE and SOPTYPE
DELETE from SOP30300 where DEX_ROW_ID = XXX and SOPNUMBE = 'XXX' and SOPTYPE = XXX
DELETE from SOP10200 where DEX_ROW_ID in('176',
'177',
'4946',
'2177',
'4947',
'3296',
'5305',
'5306',
'5307',
'178',
'1000',
'1001',
'994',
'996',
'997',
'999',
'1460',
'998',
'984',
'995',
'983',
'982',
'5304',
'5938')



