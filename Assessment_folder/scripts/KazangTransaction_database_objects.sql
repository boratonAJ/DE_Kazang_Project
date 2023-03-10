USE [master]
GO
/****** Object:  Database [KazangTransaction]    Script Date: 2/22/2023 4:56:38 PM ******/
CREATE DATABASE [KazangTransaction]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Kazang', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Kazang.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Kazang_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Kazang_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [KazangTransaction] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [KazangTransaction].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [KazangTransaction] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KazangTransaction] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KazangTransaction] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KazangTransaction] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KazangTransaction] SET ARITHABORT OFF 
GO
ALTER DATABASE [KazangTransaction] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [KazangTransaction] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [KazangTransaction] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KazangTransaction] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KazangTransaction] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KazangTransaction] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KazangTransaction] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KazangTransaction] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KazangTransaction] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KazangTransaction] SET  DISABLE_BROKER 
GO
ALTER DATABASE [KazangTransaction] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KazangTransaction] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KazangTransaction] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [KazangTransaction] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [KazangTransaction] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KazangTransaction] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KazangTransaction] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [KazangTransaction] SET RECOVERY FULL 
GO
ALTER DATABASE [KazangTransaction] SET  MULTI_USER 
GO
ALTER DATABASE [KazangTransaction] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [KazangTransaction] SET DB_CHAINING OFF 
GO
ALTER DATABASE [KazangTransaction] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [KazangTransaction] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [KazangTransaction] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [KazangTransaction] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'KazangTransaction', N'ON'
GO
ALTER DATABASE [KazangTransaction] SET QUERY_STORE = ON
GO
ALTER DATABASE [KazangTransaction] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [KazangTransaction]
GO
/****** Object:  User [kaz]    Script Date: 2/22/2023 4:56:39 PM ******/
CREATE USER [kaz] FOR LOGIN [kaz] WITH DEFAULT_SCHEMA=[Dim]
GO
ALTER ROLE [db_owner] ADD MEMBER [kaz]
GO
/****** Object:  Schema [Dim]    Script Date: 2/22/2023 4:56:39 PM ******/
CREATE SCHEMA [Dim]
GO
/****** Object:  Schema [Fact]    Script Date: 2/22/2023 4:56:39 PM ******/
CREATE SCHEMA [Fact]
GO
/****** Object:  Table [Dim].[TempTransaction]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[TempTransaction](
	[id] [varchar](50) NOT NULL,
	[created] [varchar](50) NULL,
	[primary_account_id] [varchar](50) NULL,
	[group_id] [varchar](50) NULL,
	[Primary_Type] [varchar](50) NULL,
	[transaction_amount] [varchar](50) NULL,
	[TransactionType] [varchar](200) NULL,
	[content_type] [varchar](50) NULL,
	[detail_type_name] [varchar](200) NULL,
	[primary_account_balance] [varchar](50) NULL,
	[daily_total_transaction] [float] NULL,
	[daily_opening_balance] [varchar](50) NULL,
	[transaction_type_category] [varchar](8) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DailyAccountBalanceAggregate]    Script Date: 2/22/2023 4:56:39 PM ******/
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

GO
/****** Object:  Table [Dim].[ContentType]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[ContentType](
	[id] [varchar](50) NOT NULL,
	[created] [varchar](50) NULL,
	[modified] [varchar](50) NULL,
	[description] [varchar](200) NULL,
	[currency_id] [varchar](50) NULL,
	[interface_id] [varchar](50) NULL,
	[barcode] [varchar](50) NULL,
	[barcode_type_id] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[cost] [varchar](50) NULL,
	[status] [varchar](50) NULL,
	[stock_item] [varchar](50) NULL,
	[stock_code] [varchar](50) NULL,
	[content_type_provider_id] [varchar](50) NULL,
	[dynamic_amount] [varchar](50) NULL,
	[profit_available] [varchar](50) NULL,
	[category_id] [varchar](50) NULL,
	[priority] [varchar](50) NULL,
 CONSTRAINT [PK_ContentType_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[ContentTypeProvider]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[ContentTypeProvider](
	[id] [varchar](50) NOT NULL,
	[created] [varchar](50) NULL,
	[modified] [varchar](50) NULL,
	[name] [varchar](200) NULL,
	[description] [varchar](500) NULL,
 CONSTRAINT [PK_ContentTypeProvider_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[GeneralCurrency]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[GeneralCurrency](
	[id] [varchar](50) NOT NULL,
	[code] [varchar](50) NULL,
	[prefix] [varchar](50) NULL,
	[name] [varchar](50) NULL,
	[smallest_unit] [varchar](50) NULL,
	[format_string] [varchar](50) NULL,
 CONSTRAINT [PK_GeneralCurrency_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[GeneralGroup]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[GeneralGroup](
	[id] [varchar](50) NOT NULL,
	[parent_id] [varchar](50) NULL,
	[name] [varchar](500) NULL,
	[description] [varchar](500) NULL,
	[locale_id] [varchar](50) NULL,
	[currency_id] [varchar](50) NULL,
	[country_id] [varchar](50) NULL,
	[status] [varchar](50) NULL,
 CONSTRAINT [PK_GeneralGroup_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[PrimaryAccountGroup]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[PrimaryAccountGroup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[start_date] [date] NULL,
	[TransactionJournal_id] [varchar](50) NOT NULL,
	[primary_account_id] [varchar](50) NULL,
	[group_id] [varchar](50) NULL,
	[daily_sum] [varchar](50) NULL,
	[transaction_running_average] [varchar](50) NULL,
	[end_date] [date] NULL,
 CONSTRAINT [PK_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[TransactionJournal]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[TransactionJournal](
	[id] [varchar](50) NOT NULL,
	[created] [varchar](50) NULL,
	[primary_account_id] [varchar](50) NULL,
	[parent_account_id] [varchar](50) NULL,
	[provider_account_id] [varchar](50) NULL,
	[icp_account_id] [varchar](50) NULL,
	[group_id] [varchar](50) NULL,
	[primary_type] [varchar](50) NULL,
	[transaction_amount] [varchar](50) NULL,
	[stock_cost] [varchar](50) NULL,
	[vat] [varchar](50) NULL,
	[superdealer_vat_reg] [varchar](50) NULL,
	[vendor_vat_reg] [varchar](50) NULL,
	[vendor_comm] [varchar](50) NULL,
	[superdealer_comm] [varchar](50) NULL,
	[icp_comm] [varchar](50) NULL,
	[psitek_comm] [varchar](50) NULL,
	[vendor_rbc_cost] [varchar](50) NULL,
	[bank_charge] [varchar](50) NULL,
	[bank_charge_owner] [varchar](50) NULL,
	[detail_type_name] [varchar](200) NULL,
	[detail_object_id] [varchar](50) NULL,
	[primary_account_balance] [varchar](50) NULL,
	[content_type] [varchar](50) NULL,
	[reversal_id] [varchar](50) NULL,
	[comment] [varchar](200) NULL,
 CONSTRAINT [PK_TransactionJournal_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dim].[TransactionType]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dim].[TransactionType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionType] [varchar](200) NULL,
	[TransactionPrimaryType_id] [varchar](50) NULL,
 CONSTRAINT [PK_TransactionPrimaryType_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Fact].[FactTransaction]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[FactTransaction](
	[FactTransaction_id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionJournal_id] [varchar](50) NOT NULL,
	[primary_type] [varchar](50) NULL,
	[group_id] [varchar](50) NULL,
	[ContentType_id] [varchar](50) NOT NULL,
	[transaction_amount] [varchar](50) NULL,
	[primary_account_balance] [varchar](50) NULL,
	[daily_total_transaction] [varchar](50) NULL,
	[daily_opening_balance] [varchar](50) NULL,
	[daily_closing_balance] [varchar](50) NULL,
	[TransactionType] [varchar](200) NULL,
 CONSTRAINT [PK_FactTransaction_id] PRIMARY KEY CLUSTERED 
(
	[FactTransaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Dim].[PrimaryAccountGroup]  WITH CHECK ADD  CONSTRAINT [FK_group_id] FOREIGN KEY([group_id])
REFERENCES [Dim].[GeneralGroup] ([id])
GO
ALTER TABLE [Dim].[PrimaryAccountGroup] CHECK CONSTRAINT [FK_group_id]
GO
ALTER TABLE [Dim].[PrimaryAccountGroup]  WITH CHECK ADD  CONSTRAINT [FK_TransactionJournal_id] FOREIGN KEY([TransactionJournal_id])
REFERENCES [Dim].[TransactionJournal] ([id])
GO
ALTER TABLE [Dim].[PrimaryAccountGroup] CHECK CONSTRAINT [FK_TransactionJournal_id]
GO
ALTER TABLE [Fact].[FactTransaction]  WITH CHECK ADD  CONSTRAINT [FK_ContentType_id] FOREIGN KEY([ContentType_id])
REFERENCES [Dim].[ContentType] ([id])
GO
ALTER TABLE [Fact].[FactTransaction] CHECK CONSTRAINT [FK_ContentType_id]
GO
ALTER TABLE [Fact].[FactTransaction]  WITH CHECK ADD  CONSTRAINT [FK_group_id] FOREIGN KEY([group_id])
REFERENCES [Dim].[GeneralGroup] ([id])
GO
ALTER TABLE [Fact].[FactTransaction] CHECK CONSTRAINT [FK_group_id]
GO
ALTER TABLE [Fact].[FactTransaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionJournal_id] FOREIGN KEY([TransactionJournal_id])
REFERENCES [Dim].[TransactionJournal] ([id])
GO
ALTER TABLE [Fact].[FactTransaction] CHECK CONSTRAINT [FK_TransactionJournal_id]
GO
/****** Object:  StoredProcedure [dbo].[kazang_fact_transaction_sp_load]    Script Date: 2/22/2023 4:56:39 PM ******/
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
/****** Object:  StoredProcedure [dbo].[kazang_transaction_sp_load]    Script Date: 2/22/2023 4:56:39 PM ******/
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
GO
/****** Object:  StoredProcedure [dbo].[kazang_transaction_track_sp]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[kazang_transaction_track_sp]
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
GO
/****** Object:  StoredProcedure [dbo].[track_primary_account_group_movements_sp_load]    Script Date: 2/22/2023 4:56:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[track_primary_account_group_movements_sp_load]
AS
BEGIN
SET NOCOUNT ON
select * 
into #primary_account_movement
from (
select at2.created,at2.id as TransactionJournal_id,
		at2.primary_account_id,gg.id as group_id, SUM(try_cast(at2.transaction_amount as int)) AS daily_sum,
		AVG(Sum(isnull(try_cast(at2.transaction_amount as int),0))) OVER (ORDER BY at2.created ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS transaction_running_average	
from [KazangTransaction].[Dim].[TransactionJournal] at2
inner join [KazangTransaction].[Dim].[GeneralGroup] gg on gg.id = at2.group_id
GROUP BY at2.created,at2.id,at2.primary_account_id,gg.id,at2.transaction_amount
) a

--drop table #primary_account_movement
--select * from #primary_account_movement

;with cc as (
select created,TransactionJournal_id,primary_account_id,
group_id, daily_sum,transaction_running_average,
LEAD(group_id) over (partition by primary_account_id order by created, TransactionJournal_id) NextGroupid
, LAG(CAST(created AS DATETIME2)) over (partition by primary_account_id, group_id order by created, TransactionJournal_id) StartDate
, LEAD(CAST(created AS DATETIME2)) over (partition by primary_account_id order by created, TransactionJournal_id) EndDate
 from #primary_account_movement
)
, c2 as (
  select TransactionJournal_id,primary_account_id,group_id
  , daily_sum,transaction_running_average
  , created
  , NextGroupid
  , StartDate
  , dateadd(day, -1, EndDate) EndDate
from cc
)
, c3 as (
select 
	IsNull(StartDate, CAST(created AS DATETIME2)) as StartDate
	,[TransactionJournal_id]
	,[primary_account_id]
	,[group_id]
	,[daily_sum]
	,[transaction_running_average]
	,IsNull(EndDate, '2999-01-01') as EndDate
from c2
where group_id <> NextGroupid or NextGroupid is null
)

insert into [KazangTransaction].[Dim].[PrimaryAccountGroup](
					[start_date]
					,[TransactionJournal_id]
					,[primary_account_id]
					,[group_id]
					,[daily_sum]
					,[transaction_running_average]
					,[end_date]
		)
select *
from c3
where StartDate <= EndDate

--select * from [KazangTransaction].[Dim].[PrimaryAccountGroup]

END

GO
USE [master]
GO
ALTER DATABASE [KazangTransaction] SET  READ_WRITE 
GO
