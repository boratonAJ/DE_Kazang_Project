USE [KazangTransaction]
GO

/****** Object:  StoredProcedure [dbo].[kazang_fact_transaction_sp_load]    Script Date: 2/22/2023 11:50:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[kazang_fact_transaction_sp_load]
AS
BEGIN
SET NOCOUNT ON
insert into [KazangTransaction].[Fact].[FactTransaction](
			[TransactionJournal_id]
			,[primary_type]
			,[group_id]
			,[ContentType_id]
			,[transaction_amount]
			,[primary_account_balance]
			,[daily_total_transaction]
			,[daily_opening_balance]
			,[daily_closing_balance]
			,[TransactionType]
)

select at2.id as TransactionJournal_id,tp.transactionPrimarytype_id as primary_type,
	gc.id as group_id, cc.id as ContentType_id, at2.transaction_amount,
	at2.primary_account_balance, SUM(Try_convert(float,at2.transaction_amount)) AS daily_total_transaction,
	at2.primary_account_balance as daily_opening_balance,
	case 
		when tt.transaction_type_category = 'credited' or tt.transaction_type_category = 'Debited' then (SUM(Try_convert(float,at2.transaction_amount))-LAG(SUM(Try_convert(float,at2.primary_account_balance))) OVER (ORDER BY at2.created ASC))
		END AS daily_closing_balance,
	tp.TransactionType
from [KazangTransaction].[Dim].[TransactionJournal] at2
inner join [KazangTransaction].[Dim].[ContentType] cc on at2.content_type = cc.id
inner join [KazangTransaction].[Dim].[ContentTypeProvider] cc2 on cc.content_type_provider_id = cc2.id
inner join [KazangTransaction].[Dim].[GeneralCurrency] gc on cc.currency_id = gc.id
inner join [KazangTransaction].[Dim].[GeneralGroup] gg on gg.id = at2.group_id
inner join [KazangTransaction].[Dim].[TransactionType] tp on at2.primary_type = tp.transactionPrimarytype_id
inner join [KazangTransaction].[Dim].[TempTransaction] tt on at2.id = tt.id
GROUP BY at2.id,tp.transactionPrimarytype_id,gc.id, cc.id,at2.transaction_amount,at2.created,
		at2.primary_account_balance,tp.TransactionType,tt.transaction_type_category
ORDER BY daily_total_transaction DESC;

END

GO


