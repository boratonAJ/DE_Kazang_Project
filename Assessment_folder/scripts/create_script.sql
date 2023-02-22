use ArchiveRawData
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[general_group]') AND type in (N'U'))
DROP TABLE [dbo].[general_group]
GO

CREATE TABLE general_group(
    [id] varchar(50),
    [parent_id] varchar(50),
    [name] varchar(500),
    [description] varchar(500),
    [locale_id] varchar(50),
    [currency_id] varchar(50),
    [country_id] varchar(50),
    [status] varchar(50)
)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[general_currency]') AND type in (N'U'))
DROP TABLE [dbo].[general_currency]
GO
CREATE TABLE general_currency (
    [id] varchar(50),
    [code] varchar(50),
    [prefix] varchar(50),
    [name] varchar(50),
    [smallest_unit] varchar(50),
    [format_string] varchar(50)
)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[contentmanager_contenttypeprovider]') AND type in (N'U'))
DROP TABLE [dbo].[contentmanager_contenttypeprovider]
GO
CREATE TABLE contentmanager_contenttypeprovider (
    [id] varchar(50),
    [created] varchar(50),
    [modified] varchar(50),
    [name] varchar(200),
    [description] varchar(500)
)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[contentmanager_contenttype]') AND type in (N'U'))
DROP TABLE [dbo].[contentmanager_contenttype]
GO
CREATE TABLE contentmanager_contenttype (
    [id] varchar(50),
    [created] varchar(50),
    [modified] varchar(50),
    [description] varchar(200),
    [currency_id] varchar(50),
    [interface_id] varchar(50),
    [barcode] varchar(50),
    [barcode_type_id] varchar(50),
    [value] varchar(50),
    [cost] varchar(50),
    [status] varchar(50),
    [stock_item] varchar(50),
    [stock_code] varchar(50),
    [content_type_provider_id] varchar(50),
    [dynamic_amount] varchar(50),
    [profit_available] varchar(50),
    [category_id] varchar(50),
    [priority] varchar(50)
)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accountmanager_transactionjournal]') AND type in (N'U'))
DROP TABLE [dbo].[accountmanager_transactionjournal]
GO
CREATE TABLE accountmanager_transactionjournal (
    [id] varchar(50),
    [created] varchar(50),
    [primary_account_id] varchar(50),
    [parent_account_id] varchar(50),
    [provider_account_id] varchar(50),
    [icp_account_id] varchar(50),
    [group_id] varchar(50),
    [primary_type] varchar(50),
    [transaction_amount] varchar(50),
    [stock_cost] varchar(50),
    [vat] varchar(50),
    [superdealer_vat_reg] varchar(50),
    [vendor_vat_reg] varchar(50),
    [vendor_comm] varchar(50),
    [superdealer_comm] varchar(50),
    [icp_comm] varchar(50),
    [psitek_comm] varchar(50),
    [vendor_rbc_cost] varchar(50),
    [bank_charge] varchar(50),
    [bank_charge_owner] varchar(50),
    [detail_type_name] varchar(200),
    [detail_object_id] varchar(50),
    [primary_account_balance] varchar(50),
    [content_type] varchar(50),
    [reversal_id] varchar(50),
    [comment] varchar(200)
)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[transaction_type]') AND type in (N'U'))
DROP TABLE [dbo].[transaction_type]
GO

CREATE TABLE transaction_type(
    [id] int IDENTITY(1,1) NOT NULL,
    [transaction_type] varchar(50),
    [transaction_primary_type_id] varchar(50)
)


