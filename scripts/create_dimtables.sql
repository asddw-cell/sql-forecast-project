
/*

==============================================================================

Create dimensional lookup tables

==============================================================================

Script Purpose:
	This script creates the dimensional tables that are needed to give user friendly context to forecast data.
	
	Tables created are:
	
	Global:
		tblForecastType
		tblSalesChannel
		tblBusinessUnit
		tblPriceType
		tblBrand
		tblUserLogin

	Region specific (ensure to add the regional suffix e.g. _AU, _EU, _UK, _US to table names):
		tblForecastCustomer_UK
		tblForecastCustomer_US
		tblItem_UK
		tblItem_US

*/

USE [Forecast]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Create the dimension table tblForecastType and populate values.

CREATE TABLE [dbo].[tblForecastType](
	[Code] [int] NOT NULL,
	[Description] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [dbo].[tblForecastType]
           ([Code]
           ,[Description])
     VALUES
           (1
           ,'Sales'),
		   (2
           ,'GM'),
		   (3
           ,'Purchase')
GO


-- Create the dimension table tblSalesChannel and populate values.

CREATE TABLE [dbo].[tblSalesChannel](
	[Code] [nvarchar](15) NOT NULL,
	[Description] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [dbo].[tblSalesChannel]
           ([Code]
           ,[Description])
     VALUES
           ('DOMESTIC'
           ,'Domestic'),
		   ('ECOMM'
           ,'ECommerce'),
		   ('FOB/DTR'
           ,'FOB/DI')
GO


-- Create the dimension table tblBusinessUnit and populate values.

CREATE TABLE [dbo].[tblBusinessUnit](
	[Code] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO [dbo].[tblBusinessUnit]
           ([Code]
           ,[Description])
     VALUES
           (1
           ,'Games'),
		   (2
           ,'Toys')
GO


-- Create the dimension table tblPriceType and populate values.

CREATE TABLE [dbo].[tblPriceType](
	[Code] [int] NOT NULL,
	[Description] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[tblPriceType]
           ([Code]
           ,[Description])
     VALUES
           (1
           ,'List'),
		   (2
           ,'Special')
GO


-- Create the dimension table tblBrand. Values will be populated on a schedule via stored procedure.

CREATE TABLE [dbo].[tblBrand](
	[Code] [nvarchar](25) NOT NULL,
	[Description] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Create the dimension table tblUserLogin. Values will be populated manually.

CREATE TABLE [dbo].[Userlogin](
	[UserLogin] [nvarchar](max) NOT NULL,
	[ForecastingCustomer] [nvarchar](20) NOT NULL,
	[TableToAccess] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-- Create the dimension table tblForecastCustomer_UK. Values will be populated via stored procedure.

CREATE TABLE [dbo].[tblForecastCustomer_UK](
	[Code] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Active] [bit],
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Create the dimension table tblForecastCustomer_US. Values will be populated via stored procedure.

CREATE TABLE [dbo].[tblForecastCustomer_US](
	[Code] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Active] [bit],
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Create the dimension table tblItem_UK. Values will be populated on a schedule via stored procedure.

CREATE TABLE [dbo].[tblItem_UK](
	[ItemNo] [nvarchar](20) NOT NULL,
	[Item] [nvarchar](123) NOT NULL,
	[BrandName] [nvarchar](50) NOT NULL,
	[BrandCode] [nvarchar](25) NOT NULL,
	[BrandBrand] [nvarchar](175) NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ItemNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Create the dimension table tblItem_US. Values will be populated on a schedule via stored procedure.

CREATE TABLE [dbo].[tblItem_US](
	[ItemNo] [nvarchar](20) NOT NULL,
	[Item] [nvarchar](123) NOT NULL,
	[BrandName] [nvarchar](50) NOT NULL,
	[BrandCode] [nvarchar](25) NOT NULL,
	[BrandBrand] [nvarchar](175) NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ItemNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
