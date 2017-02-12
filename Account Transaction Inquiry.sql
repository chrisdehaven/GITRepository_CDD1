SELECT     TOP (100) PERCENT Series, [Originating Control Number] AS [Voucher Number], [Originating Document Number] AS [Invoice Number], 
                      [Originating Posted Date] AS [Posted Date], [Account Number], [Account Description], [Credit Amount], [Debit Amount]
FROM         dbo.AccountTransactions
WHERE     ([Originating Posted Date] = CONVERT(DATETIME, '2015-01-30 00:00:00', 102)) AND ([Originating Control Number] BETWEEN '20150001' AND '20150577')
ORDER BY [Voucher Number]