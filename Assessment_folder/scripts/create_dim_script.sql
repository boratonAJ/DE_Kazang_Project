USE [KazangTransaction]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Fact].[FactTransaction]') AND type in (N'U'))
DROP TABLE [Fact].[FactTransaction]
GO

CREATE TABLE [Fact].[FactTransaction] (
	[FactTransaction_id] int IDENTITY(1,1) NOT NULL,
	[TransactionJournal_id] [varchar](50) NOT NULL,
	[primary_type] varchar(50),
	[group_id] [varchar](50) NULL,
	[ContentType_id] [varchar](50) NOT NULL,
	[transaction_amount] [varchar](50) NULL,
	[primary_account_balance] [varchar](50) NULL,
	[daily_total_transaction] [varchar](50) NULL,
    [daily_opening_balance] [varchar](50) NULL,
    [daily_closing_balance] [varchar](50) NULL,
	[TransactionType] varchar(200),
	CONSTRAINT PK_FactTransaction_id PRIMARY KEY (FactTransaction_id),
	CONSTRAINT FK_TransactionJournal_id FOREIGN KEY (TransactionJournal_id)
        REFERENCES [Dim].[TransactionJournal] (id),
	CONSTRAINT FK_group_id FOREIGN KEY (group_id)
        REFERENCES [Dim].[GeneralGroup] (id),
    CONSTRAINT FK_ContentType_id FOREIGN KEY (ContentType_id)
        REFERENCES [Dim].[ContentType] (id),
)
Go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[ContentType]') AND type in (N'U'))
DROP TABLE [Dim].[ContentType]
GO
/****** Object:  Table [Dim].[ContentType]    Script Date: 2/20/2023 5:06:54 AM ******/
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
	CONSTRAINT PK_ContentType_id PRIMARY KEY (id)
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[ContentTypeProvider]') AND type in (N'U'))
DROP TABLE [Dim].[ContentTypeProvider]
GO
/****** Object:  Table [Dim].[ContentTypeProvider]    Script Date: 2/20/2023 5:06:54 AM ******/
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
	CONSTRAINT PK_ContentTypeProvider_id PRIMARY KEY (id)
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[GeneralCurrency]') AND type in (N'U'))
DROP TABLE [Dim].[GeneralCurrency]
GO
/****** Object:  Table [Dim].[GeneralCurrency]    Script Date: 2/20/2023 5:06:54 AM ******/
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
	CONSTRAINT PK_GeneralCurrency_id PRIMARY KEY (id)
)
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[GeneralGroup]') AND type in (N'U'))
DROP TABLE [Dim].[GeneralGroup]
GO

/****** Object:  Table [Dim].[GeneralGroup]    Script Date: 2/20/2023 5:06:54 AM ******/
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
	CONSTRAINT PK_GeneralGroup_id PRIMARY KEY (id)
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[TransactionJournal]') AND type in (N'U'))
DROP TABLE [Dim].[TransactionJournal]
GO

/****** Object:  Table [Dim].[TransactionJournal]    Script Date: 2/20/2023 5:06:54 AM ******/
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
	CONSTRAINT PK_TransactionJournal_id PRIMARY KEY (id)
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[TransactionType]') AND type in (N'U'))
DROP TABLE [Dim].[TransactionType]
GO

CREATE TABLE [Dim].[TransactionType](
    [id] int IDENTITY(1,1) NOT NULL,
    [TransactionType] varchar(200),
    [TransactionPrimaryType_id] varchar(50),
	CONSTRAINT PK_TransactionPrimaryType_id PRIMARY KEY (id)
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[TempTransaction]') AND type in (N'U'))
DROP TABLE [Dim].[TempTransaction]
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Dim].[PrimaryAccountGroup]') AND type in (N'U'))
DROP TABLE [Dim].[PrimaryAccountGroup]
GO

CREATE TABLE [Dim].[PrimaryAccountGroup](
	 [id] int IDENTITY(1,1) NOT NULL,
	 [start_date] Date,
	 [TransactionJournal_id] [varchar](50) NOT NULL,
	 [primary_account_id] [varchar](50) NULL,
	 [group_id] [varchar](50) NULL,
	 [daily_sum]  [varchar](50) NULL,
	 [transaction_running_average] [varchar](50) NULL,
	 [end_date] Date,
	 CONSTRAINT PK_id PRIMARY KEY (id),
	 CONSTRAINT FK_TransactionJournal_id FOREIGN KEY (TransactionJournal_id)
        REFERENCES [Dim].[TransactionJournal] (id),
	 CONSTRAINT FK_group_id FOREIGN KEY (group_id)
        REFERENCES [Dim].[GeneralGroup] (id)
)

