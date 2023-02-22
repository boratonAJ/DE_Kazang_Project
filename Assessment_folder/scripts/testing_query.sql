/****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*) as cnt
  FROM [ArchiveRawData].[dbo].[accountmanager_transactionjournal]

SELECT Primary_Type, count(Primary_Type) as Primary_Type_cnt
  FROM [ArchiveRawData].[dbo].[accountmanager_transactionjournal]
group by Primary_Type
order by Primary_Type DESC

  SELECT *
  FROM [ArchiveRawData].[dbo].[general_group]

    SELECT *
  FROM [ArchiveRawData].[dbo].[general_currency]

    SELECT *
  FROM [ArchiveRawData].[dbo].[contentmanager_contenttypeprovider]

    SELECT *
  FROM [ArchiveRawData].[dbo].[contentmanager_contenttype]

    SELECT *
  FROM [ArchiveRawData].[dbo].[transaction_type]
  where transaction_type in('GENERIC_SD_COMMISSION','GENERIC_VAT_ON_PSITEK_COMMISSION',
  'GENERIC_VAT_ON_DEVICE_COMMISSION','GENERIC_DEVICE_COMMISSION')
  



  

--select * from [ArchiveRawData].[dbo].[general_group]
truncate table [ArchiveRawData].[dbo].[general_group]
truncate table [ArchiveRawData].[dbo].[general_currency]
truncate table [ArchiveRawData].[dbo].[accountmanager_transactionjournal]
truncate table [ArchiveRawData].[dbo].[contentmanager_contenttype]
truncate table [ArchiveRawData].[dbo].[contentmanager_contenttypeprovider]




--select * from [KazangTransaction].[dbo].[GeneralGroup]
truncate table [KazangTransaction].[Dim].[GeneralGroup]
truncate table [KazangTransaction].[Dim].[GeneralCurrency]
truncate table [KazangTransaction].[Dim].[TransactionJournal]
truncate table [KazangTransaction].[Dim].[ContentType]
truncate table [KazangTransaction].[Dim].[ContentTypeProvider]
truncate table [KazangTransaction].[Dim].[TransactionType]


--The following Query explains the relationships with regards to all other csv tabular data provided
select * from
[ArchiveRawData].[dbo].[accountmanager_transactionjournal] at2
inner join [ArchiveRawData].[dbo].[contentmanager_contenttype] cc on at2.content_type = cc.id
inner join [ArchiveRawData].[dbo].[contentmanager_contenttypeprovider] cc2 on cc.content_type_provider_id = cc2.id
inner join [ArchiveRawData].[dbo].[general_currency] gc on cc.currency_id = gc.id
inner join [ArchiveRawData].[dbo].[general_group] gg on gg.id = at2.group_id


select * from
[ArchiveRawData].[dbo].[accountmanager_transactionjournal] at2
inner join [KazangTransaction].[Dim].[ContentType] cc on at2.content_type = cc.id
inner join [KazangTransaction].[Dim].[ContentTypeProvider] cc2 on cc.content_type_provider_id = cc2.id
inner join [KazangTransaction].[Dim].[GeneralCurrency] gc on cc.currency_id = gc.id
inner join [KazangTransaction].[Dim].[GeneralGroup] gg on gg.id = at2.group_id
inner join [KazangTransaction].[Dim].[TransactionType] tt on at2.primary_type = tt.TransactionPrimaryType_id









-- Checks for schemas
SELECT s.name AS schema_name, 
       s.schema_id, 
       u.name AS schema_owner
FROM sys.schemas s
     INNER JOIN sys.sysusers u ON u.uid = s.principal_id
ORDER BY s.name;


--Create Schemas
--https://www.sqlshack.com/a-walkthrough-of-sql-schema/



-- Renaming database
ALTER DATABASE [Kazang] MODIFY NAME = [KazangTransaction]

--Adding Primary Keys
ALTER TABLE [KazangTransaction].[dbo].[generalgroup] ADD CONSTRAINT PK_id PRIMARY KEY (id);
ALTER TABLE [KazangTransaction].[dbo].[generalcurrency] ADD CONSTRAINT PK_id PRIMARY KEY (id);
ALTER TABLE [KazangTransaction].[dbo].[accountmanagertransactionjournal] ADD CONSTRAINT PK_id PRIMARY KEY (id);
ALTER TABLE [KazangTransaction].[dbo].[contentmanagercontenttype] ADD CONSTRAINT PK_id PRIMARY KEY (id);
ALTER TABLE [KazangTransaction].[dbo].[contentmanagercontenttypeprovider] ADD CONSTRAINT PK_id PRIMARY KEY (id);


-- Select DIm Tables
select * from [KazangTransaction].[Dim].[TransactionJournal]
select * from [KazangTransaction].[Dim].[TransactionType]

select count(*) as cnt from [KazangTransaction].[Dim].[TransactionJournal] tj
join [KazangTransaction].[Dim].[TransactionType]
groupby tj.primary_type


SELECT tj.created, tj.primary_account_balance,tj.transaction_amount, tj.Primary_Type, tp.TransactionType, count(tj.Primary_Type) as Primary_Type_cnt
  FROM [KazangTransaction].[Dim].[TransactionJournal] tj
  join [KazangTransaction].[Dim].[TransactionType] tp on tj.primary_type = tp.transactionPrimarytype_id
group by tj.created,tj.primary_account_balance, tj.Primary_Type, tp.TransactionType,tj.transaction_amount
order by primary_account_balance DESC
where  primary_type in ('0', '534')




--drop table 
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[TempTransaction]') AND type in (N'U'))
--DROP TABLE [Dim].[TempTransaction]

---- execute the stored procedure
--exec  [KazangTransaction].[dbo].[kazang_transaction_track_sp]
-- exec [KazangTransaction].[dbo].[kazang_transaction_sp_load]
--select * from [KazangTransaction].[Dim].[TempTransaction]
-- exec  [KazangTransaction].[dbo].[kazang_fact_transaction_sp_load]
-- select * from [KazangTransaction].[Fact].[FactTransaction]



SELECT  DATEPART(YEAR, date_created) AS year,
		DATEPART(DAY, date_created) AS day,
        DATEPART(QUARTER, date_created) AS quarter
FROM [KazangTransaction].[Dim].[TempTransaction]


SELECT tj.id,tj.created as date_created, tj.primary_account_id, tj.group_id, tj.Primary_Type, tj.transaction_amount, 
	tp.TransactionType,tj.content_type, tj.detail_type_name,tj.primary_account_balance,
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
ORDER BY daily_total_transaction DESC;
GO

--drop table [KazangTransaction].[Dim].[TempTransaction] 
--SELECT 
--	*
--FROM #TempTransaction
--where primary_type='282'

SELECT id,date_created, primary_account_id, group_id, Primary_Type, transaction_amount, 
	TransactionType,content_type, detail_type_name,primary_account_balance,
	daily_total_transaction,daily_opening_balance,
	case 
		when transaction_type_category = 'credited' then (SUM(Try_convert(float,transaction_amount))+LAG(SUM(Try_convert(float,primary_account_balance))) OVER (ORDER BY created ASC))
		when transaction_type_category = 'Debited' then (SUM(Try_convert(float,transaction_amount))-LAG(SUM(Try_convert(float,primary_account_balance))) OVER (ORDER BY created ASC))
		END AS daily_closing_balance
FROM [KazangTransaction].[Dim].[TempTransaction]
GROUP BY id,created, primary_account_id, group_id, Primary_Type, transaction_amount, 
	TransactionType,content_type, detail_type_name,primary_account_balance,
	daily_total_transaction,daily_opening_balance,transaction_type_category
ORDER BY daily_total_transaction DESC;










select * from [KazangTransaction].[Dim].[TransactionJournal]
where  primary_type in ('0', '534')

-- Create Facts
--The following Query explains the relationships with regards to all other csv tabular data provided
select * from
[KazangTransaction].[Dim].[TransactionJournal] at2
inner join [KazangTransaction].[Dim].[ContentType] cc on at2.content_type = cc.id
inner join [KazangTransaction].[Dim].[ContentTypeProvider] cc2 on cc.content_type_provider_id = cc2.id
inner join [KazangTransaction].[Dim].[GeneralCurrency] gc on cc.currency_id = gc.id
inner join [KazangTransaction].[Dim].[GeneralGroup] gg on gg.id = at2.group_id
inner join [KazangTransaction].[Dim].[TransactionType] tp on at2.primary_type = tp.transactionPrimarytype_id

--where at2.primary_account_id = '262072'


select * from
[KazangTransaction].[Dim].[TransactionJournal]
where primary_account_id = '5795'


SELECT [date_created]
      ,[day]
      ,[primary_account_id]
      ,[Primary_Type]
      ,[transaction_amount]
      ,[primary_account_balance]
      ,[daily_total_transaction]
      ,[daily_opening_balance]
      ,[daily_closing_balance]
  FROM [KazangTransaction].[dbo].[DailyAccountBalanceAggregate]
  WHERE [primary_account_id] = '482775'