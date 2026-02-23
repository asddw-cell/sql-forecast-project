USE [Forecast]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE if exists #temp
CREATE TABLE #temp(
	[SalesChannel] [nvarchar](15) NOT NULL,
	[ForecastCustomer] [nvarchar](20) NOT NULL,
	[Year] [int] NOT NULL,
	[MonthNum] [int] NOT NULL,
	[Brand] [nvarchar](25) NOT NULL,
	[ItemNo] [nvarchar](20) NOT NULL,
	[Price] [decimal](38, 20) NOT NULL,
	[PriceType] [int] NOT NULL,
	[Quantity] [decimal](38, 20) NOT NULL)

BULK INSERT #temp
FROM 'i:\external data\us import.csv'
WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2
	)

INSERT INTO [dbo].[tblForecastData_US]

SELECT
	1 AS [ForecastType],
	[SalesChannel],
	[ForecastCustomer],
	[Year],
	[MonthNum],
	[Brand],
	[ItemNo],
	[Quantity],
	[Price],
	[PriceType],
	YEAR(DATEADD(MONTH, 3, GETDATE())) * 100 +MONTH(DATEADD(MONTH, 3, GETDATE()))

FROM #temp
