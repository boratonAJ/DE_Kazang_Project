USE [KazangTransaction]
GO

/****** Object:  StoredProcedure [KazangTransaction].[Dim].[TempTransaction]   Script Date: 2/22/2023 6:36:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[kazang_transaction_sp_load]
AS
BEGIN
SET NOCOUNT ON

MERGE [KazangTransaction].[Dim].[TempTransaction] AS tgt
	USING	(	SELECT 
						tj.id,tj.created, 
						tj.primary_account_id, 
						tj.group_id, 
						tj.Primary_Type, 
						tj.transaction_amount, 
						--tp.TransactionType,
						tj.content_type, 
						tj.detail_type_name,
						tj.primary_account_balance
				FROM (
						SELECT 
							tj.id,tj.created, 
							tj.primary_account_id, 
							tj.group_id, 
							tj.Primary_Type, 
							tj.transaction_amount, 
							--tp.TransactionType,
							tj.content_type, 
							tj.detail_type_name,
							tj.primary_account_balance
							--row_number() over (partition by tj.created, tj.Primary_Type, tj.transaction_amount, tj.primary_account_balance order by  tj.created desc) r
						FROM [KazangTransaction].[Dim].[TransactionJournal] tj
						--JOIN [KazangTransaction].[Dim].[TransactionType] tp on tj.primary_type = tp.transactionPrimarytype_id
						WHERE tj.id IS NOT NULL
								) tj
						--WHERE r = 1
			) src

			ON src.created = tgt.created
				AND src.Primary_Type = tgt.Primary_Type
				AND src.transaction_amount = tgt.transaction_amount
				AND src.primary_account_balance = tgt.primary_account_balance
			WHEN MATCHED THEN UPDATE
			SET tgt.primary_account_id = src.primary_account_id
				, tgt.group_id = src.group_id
				, tgt.Primary_Type = src.Primary_Type
				--, tgt.TransactionType = src.TransactionType
				, tgt.content_type = src.content_type
				, tgt.detail_type_name = src.detail_type_name
				, tgt.primary_account_balance = src.primary_account_balance
			WHEN NOT MATCHED THEN
		INSERT	(
					id,created,
					primary_account_id, 
					group_id, 
					Primary_Type, 
					transaction_amount,
					content_type, 
					detail_type_name,
					primary_account_balance
				)
		
		VALUES	(
					id,created,
					primary_account_id, 
					group_id, 
					Primary_Type, 
					transaction_amount, 
					content_type, 
					detail_type_name,
					primary_account_balance
				)
	;
						

END
--drop table #TempTransaction
