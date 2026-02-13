
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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[tblForecastData_US]', 'U') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[tblForecastData_US]
		SET (SYSTEM_VERSIONING = OFF);

	DROP TABLE [dbo].[tblForecastData_US];
	DROP TABLE [dbo].[tblForecastData_USHistory];
END
GO


/* =========================================================
   1️⃣ Create Main Table
   ========================================================= */

CREATE TABLE [dbo].[tblForecastData_US] (
	[EntryNo] [int] IDENTITY(1, 1) NOT NULL,
	[ForecastType] [int] NOT NULL,
	[SalesChannel] [nvarchar](15) NOT NULL,
	[ForecastCustomer] [nvarchar](20) NOT NULL,
	[Year] [int] NOT NULL,
	[MonthNum] [int] NOT NULL,
	[BusinessUnit] [int] NULL,
	[Brand] [nvarchar](25) NOT NULL,
	[ItemNo] [nvarchar](20) NOT NULL,
	[Quantity] [decimal](38, 20) NOT NULL,
	[Price] [decimal](38, 20) NOT NULL,
	[PriceType] [int] NOT NULL,
	[OpenDateKey] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,

	PRIMARY KEY CLUSTERED ([EntryNo] ASC),

	CONSTRAINT FK_tblForecastData_US_ForecastType FOREIGN KEY ([ForecastType]) 
		REFERENCES [dbo].[tblForecastType]([Code]),

	CONSTRAINT FK_tblForecastData_US_SalesChannel FOREIGN KEY ([SalesChannel]) 
		REFERENCES [dbo].[tblSalesChannel]([Code]),

	CONSTRAINT FK_tblForecastData_US_ForecastCustomer FOREIGN KEY ([ForecastCustomer]) 
		REFERENCES [dbo].[tblForecastCustomer_US]([Code]),

	CONSTRAINT FK_tblForecastData_US_BusinessUnit FOREIGN KEY ([BusinessUnit]) 
		REFERENCES [dbo].[tblBusinessUnit]([Code]),

	CONSTRAINT FK_tblForecastData_US_Brand FOREIGN KEY ([Brand]) 
		REFERENCES [dbo].[tblBrand]([Code]),

	CONSTRAINT FK_tblForecastData_US_ItemNo FOREIGN KEY ([ItemNo]) 
		REFERENCES [dbo].[tblItem_US]([ItemNo]),

	CONSTRAINT FK_tblForecastData_US_PriceType FOREIGN KEY ([PriceType]) 
		REFERENCES [dbo].[tblPriceType]([Code]),

	PERIOD FOR SYSTEM_TIME([SysStartTime], [SysEndTime])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[tblForecastData_USHistory]))
GO


/* =========================================================
   2️⃣ Add Default Values for Temporal Columns
   ========================================================= */

ALTER TABLE [dbo].[tblForecastData_US]
ADD DEFAULT (GETUTCDATE()) FOR [SysStartTime]
GO

ALTER TABLE [dbo].[tblForecastData_US]
ADD DEFAULT (CONVERT(datetime2, '9999-12-31 23:59:59.9999999'))
FOR [SysEndTime]
GO


/* =========================================================
   3️⃣ Enforce Business Uniqueness Rule
   =========================================================

   This UNIQUE INDEX enforces that there can only be one row
   per:

       ForecastType
       SalesChannel
       ForecastCustomer
       Year
       MonthNum
       BusinessUnit
       Brand
       ItemNo
       PriceType
       Price

   This prevents accidental duplicate month/price combinations.
*/

CREATE UNIQUE NONCLUSTERED INDEX UX_tblForecastData_US_BusinessKey_WithPrice
ON dbo.tblForecastData_US
(
	ForecastType,
	SalesChannel,
	ForecastCustomer,
	[Year],
	MonthNum,
	BusinessUnit,
	Brand,
	ItemNo,
	PriceType,
	Price
);
GO
