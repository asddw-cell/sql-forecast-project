/*

==============================================================================

Create transactional ForecastData table for US

==============================================================================

Script Purpose:
	This script creates a system versioned table called 'tblForecastData_US' after checking if it already exists.
	If the table exists, it is dropped and recreated. Also creates primary and foreign keys.

Warning:
	Running this script will drop the entire 'tblForecastData_US' table if it exists.
	All data in the table will be permanently deleted. Proceed with caution and ensure you have proper backups 
	before running this script.
*/

USE [Forecast]
GO

/****** Object:  Table [dbo].[tblForecastData_US]    Script Date: 06/02/2026 14:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[tblForecastData_US]', 'U') IS NOT NULL
BEGIN
	-- Disable system versioning first
	ALTER TABLE [dbo].[tblForecastData_US]
		SET (SYSTEM_VERSIONING = OFF);

	DROP TABLE [dbo].[tblForecastData_US];
	DROP TABLE [dbo].[tblForecastData_USHistory];
END
GO

-- Create the transactional Forecast table for US
CREATE TABLE [dbo].[tblForecastData_US] (
	[EntryNo] [int] IDENTITY(1, 1) NOT NULL
	,[ForecastType] [int] NOT NULL
	,[SalesChannel] [nvarchar](15) NOT NULL
	,[ForecastCustomer] [nvarchar](20) NOT NULL
	,[Year] [int] NOT NULL
	,[MonthNum] [int] NOT NULL
	,[ItemCategory] [nvarchar](20) NULL
	,[Brand] [nvarchar](25) NOT NULL
	,[ItemNo] [nvarchar](20) NOT NULL
	,[Quantity] [decimal](38, 20) NOT NULL
	,[Price] [decimal](38, 20) NOT NULL
	,[PriceType] [int] NOT NULL
	,[CreatedDate] [datetime] NULL
	,[CreatedBy] [nvarchar](50) NULL
	,[ModifiedDate] [datetime] NULL
	,[ModifiedBy] [nvarchar](50) NULL
	,[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL
	,[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL
	,
	-- Add primary key to EntryNo
	PRIMARY KEY CLUSTERED ([EntryNo] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
		) ON [PRIMARY]
	-- Add foreign key constraint for ForecastType
	,CONSTRAINT FK_tblForecastData_US_ForecastType FOREIGN KEY ([ForecastType]) 
		REFERENCES [dbo].[tblForecastType]([Code])
	-- Add foreign key constraint for SalesChannel
	,CONSTRAINT FK_tblForecastData_US_SalesChannel FOREIGN KEY ([SalesChannel]) 
		REFERENCES [dbo].[tblSalesChannel]([Code])
	-- Add foreign key constraint for ForecastCustomer
	,CONSTRAINT FK_tblForecastData_US_ForecastCustomer FOREIGN KEY ([ForecastCustomer]) 
		REFERENCES [dbo].[tblForecastCustomer_US]([Code])
	-- Add foreign key constraint for Brand
	,CONSTRAINT FK_tblForecastData_US_Brand FOREIGN KEY ([Brand]) 
		REFERENCES [dbo].[tblBrand]([Code])
	-- Add foreign key constraint for ItemNo
	,CONSTRAINT FK_tblForecastData_US_ItemNo FOREIGN KEY ([ItemNo]) 
		REFERENCES [dbo].[tblItem_US]([ItemNo])
	-- Add foreign key constraint for PriceType
	,CONSTRAINT FK_tblForecastData_US_PriceType FOREIGN KEY ([PriceType]) 
		REFERENCES [dbo].[tblPriceType]([Code])
	,PERIOD FOR SYSTEM_TIME([SysStartTime], [SysEndTime])
	) ON [PRIMARY]
	-- Add history table for recording changes
	WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[tblForecastData_USHistory]))
GO

-- Define default versioning start and end dates for rows
ALTER TABLE [dbo].[tblForecastData_US] ADD DEFAULT(getutcdate())
FOR [SysStartTime]
GO

ALTER TABLE [dbo].[tblForecastData_US] ADD DEFAULT(CONVERT([datetime2], '9999 - 12 - 31 23 : 59 : 59.9999999'))
FOR [SysEndTime]
GO
