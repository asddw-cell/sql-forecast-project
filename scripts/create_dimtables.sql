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
		tblBrand
		tblPriceType
		tblUserLogin

	Region specific:
		tblForecastCustomer
		tblItemCategory
		tblItem

*/

USE [Forecast]
GO

/****** Object:  Table [dbo].[tblForecastData_US]    Script Date: 06/02/2026 14:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Create the dimension table tblForecastType and populate values
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

-- Create the dimension table tblSalesChannel and populate values
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
