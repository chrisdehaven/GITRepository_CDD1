http://support.microsoft.com/kb/850182

Invoices show as open even though the unapplied amount is zero in Microsoft Dynamics GP Print Print Email Email
Article ID: 850182 - View products that this article applies to.
Expand all | Collapse all
Collapse imageSYMPTOMS
The vendor information in the Payables Transaction Inquiry - Vendor window in Microsoft Dynamics GP displays the following conditions:
A transaction has a status of OPEN in the Origin column.
The amount in the Unapplied Amount box is $0.00.
You expect that the transaction has a status of HIST when the amount in the Unapplied Amount box is $0.00.
Back to the topBack to the top | Give Feedback
Collapse imageCAUSE
This problem may occur if the transactions contain unposted select check batches. In this case, the transactions have a status of Open and an unapplied amount of zero.
Back to the topBack to the top | Give Feedback
Collapse imageMORE INFORMATION
To determine whether the transactions contain unposted select check batches, follow these steps:
Click the transaction in the "Payables Transaction Inquiry - Vendor" window. Then, click Unapplied Amount.
Click the Show Details button that is to the right of the Currency ID column header.
Determine whether there is both a document number and a payment number. If there is no document number but there is a payment number, this means that the invoice has been selected for payment but the check is not yet printed or posted.
Close the Payables Apply Zoom window, and then locate the payment number in the "Payables Transaction Inquiry - Vendor" window. 

Note The status of the payment number in the Origin column is WORK.
Back to the topBack to the top | Give Feedback
Collapse imageRESOLUTION
To resolve this problem, use one of the following methods:
Delete the check batch.
Post the check batch.
Back to the topBack to the top | Give Feedback
