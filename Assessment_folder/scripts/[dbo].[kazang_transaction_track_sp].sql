USE [KazangTransaction]
GO

/****** Object:  StoredProcedure [KazangTransaction].[Dim].[TempTransaction]   Script Date: 2/22/2023 6:36:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE  [dbo].[kazang_transaction_track_sp]
AS
BEGIN
SET NOCOUNT ON

SELECT 
	tj.id,tj.created,
	tj.primary_account_id, 
	tj.group_id, 
	tj.Primary_Type, 
	tj.transaction_amount, 
	tp.TransactionType,
	tj.content_type, 
	tj.detail_type_name,
	tj.primary_account_balance,
	SUM(Try_convert(float,tj.transaction_amount)) AS daily_total_transaction,
	tj.primary_account_balance as daily_opening_balance,
	--(SUM(Try_convert(float,tj.transaction_amount))-LAG(SUM(Try_convert(float,tj.primary_account_balance))) OVER (ORDER BY tj.created ASC)) AS daily_closing_balance,
CASE
	WHEN tj.Primary_Type = '0' OR tj.Primary_Type = '534' THEN 'Credited'
	ELSE 'Debited' 
END AS transaction_type_category
INTO [KazangTransaction].[Dim].[TempTransaction]
FROM [KazangTransaction].[Dim].[TransactionJournal] tj
JOIN [KazangTransaction].[Dim].[TransactionType] tp on tj.primary_type = tp.transactionPrimarytype_id
GROUP BY tj.id,tj.primary_account_id, tj.group_id, tj.Primary_Type, tj.created, 
	tj.primary_account_balance,tj.transaction_amount, 
	tp.TransactionType,tj.content_type, tj.detail_type_name
ORDER BY daily_total_transaction DESC
					

END
--drop table #TempTransaction
