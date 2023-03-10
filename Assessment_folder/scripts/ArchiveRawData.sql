USE [master]
GO
/****** Object:  Database [ArchiveRawData]    Script Date: 2/22/2023 4:59:21 PM ******/
CREATE DATABASE [ArchiveRawData]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Archive_Raw_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Archive_Raw_Data.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Archive_Raw_Data_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Archive_Raw_Data_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ArchiveRawData] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ArchiveRawData].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ArchiveRawData] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ArchiveRawData] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ArchiveRawData] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ArchiveRawData] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ArchiveRawData] SET ARITHABORT OFF 
GO
ALTER DATABASE [ArchiveRawData] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ArchiveRawData] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ArchiveRawData] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ArchiveRawData] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ArchiveRawData] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ArchiveRawData] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ArchiveRawData] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ArchiveRawData] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ArchiveRawData] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ArchiveRawData] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ArchiveRawData] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ArchiveRawData] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ArchiveRawData] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ArchiveRawData] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ArchiveRawData] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ArchiveRawData] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ArchiveRawData] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ArchiveRawData] SET RECOVERY FULL 
GO
ALTER DATABASE [ArchiveRawData] SET  MULTI_USER 
GO
ALTER DATABASE [ArchiveRawData] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ArchiveRawData] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ArchiveRawData] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ArchiveRawData] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ArchiveRawData] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ArchiveRawData] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ArchiveRawData', N'ON'
GO
ALTER DATABASE [ArchiveRawData] SET QUERY_STORE = ON
GO
ALTER DATABASE [ArchiveRawData] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ArchiveRawData]
GO
/****** Object:  Table [dbo].[accountmanager_transactionjournal]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accountmanager_transactionjournal](
	[id] [varchar](50) NULL,
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
	[comment] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contentmanager_contenttype]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contentmanager_contenttype](
	[id] [varchar](50) NULL,
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
	[priority] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contentmanager_contenttypeprovider]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contentmanager_contenttypeprovider](
	[id] [varchar](50) NULL,
	[created] [varchar](50) NULL,
	[modified] [varchar](50) NULL,
	[name] [varchar](200) NULL,
	[description] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[general_currency]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[general_currency](
	[id] [varchar](50) NULL,
	[code] [varchar](50) NULL,
	[prefix] [varchar](50) NULL,
	[name] [varchar](50) NULL,
	[smallest_unit] [varchar](50) NULL,
	[format_string] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[general_group]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[general_group](
	[id] [varchar](50) NULL,
	[parent_id] [varchar](50) NULL,
	[name] [varchar](500) NULL,
	[description] [varchar](500) NULL,
	[locale_id] [varchar](50) NULL,
	[currency_id] [varchar](50) NULL,
	[country_id] [varchar](50) NULL,
	[status] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transaction_type]    Script Date: 2/22/2023 4:59:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transaction_type](
	[transaction_type] [nvarchar](max) NULL,
	[transaction_primary_type_id] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [ArchiveRawData] SET  READ_WRITE 
GO
