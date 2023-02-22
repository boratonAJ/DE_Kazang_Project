USE [KazangTransaction]
GO

/****** Object:  View [dbo].[DailyAccountBalanceAggregate]    Script Date: 2/22/2023 8:51:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DailyAccountBalanceAggregate] 
AS
SELECT created as date_created, DATEPART(DAY, created) AS day,primary_account_id, Primary_Type, transaction_amount, 
	primary_account_balance,daily_total_transaction,daily_opening_balance,
	case 
		--when transaction_type_category = 'credited' then (SUM(Try_convert(float,transaction_amount))+LAG(SUM(Try_convert(float,primary_account_balance))) OVER (ORDER BY date_created ASC))
		when transaction_type_category = 'credited' or transaction_type_category = 'Debited' then (SUM(Try_convert(float,transaction_amount))-LAG(SUM(Try_convert(float,primary_account_balance))) OVER (ORDER BY created ASC))
		END AS daily_closing_balance
FROM [KazangTransaction].[Dim].[TempTransaction]
GROUP BY ROLLUP(DATEPART(DAY, created), created, primary_account_id, Primary_Type, transaction_amount, 
	primary_account_balance,daily_total_transaction,daily_opening_balance,transaction_type_category)

