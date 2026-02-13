

/*

==============================================================================

Import ForecastData for US

==============================================================================

Script Purpose:
	This script inserts initial data to tblForecastData_US from a SELECT statement against the Sales Forecast fact table
    in the US staging database. The @StartDate variable is used to filter the data.
	

*/
USE [Forecast]
GO

DECLARE 
	@StartDate AS date,
	@GetDate AS datetime;

SET @StartDate = '2026-04-01';
SET	@GetDate = GETDATE();

INSERT INTO [dbo].[tblForecastData_US] (
	[ForecastType]
	,[SalesChannel]
	,[ForecastCustomer]
	,[Year]
	,[MonthNum]
	,[BusinessUnit]
	,[Brand]
	,[ItemNo]
	,[Quantity]
	,[Price]
	,[PriceType]
	,[DateKey]
	,[OpenDateKey]
	,[CreatedDate]
	,[CreatedBy]
	,[ModifiedDate]
	,[ModifiedBy]
	)
SELECT 1 AS [Forecast Type]
	,[Domestic_FOB] AS [SalesChannel]
	,[ForecastingEntity]
	,YEAR([Date]) AS [Year]
	,MONTH([Date]) AS [MonthNum]
	,1 AS [BusinessUnit]
	,[Brand_Code] AS [Brand]
	,[Item No_] AS [ItemNo]
	,SUM([Quantity])
	,SUM([Forecast Sales NSP]) / SUM([Quantity]) AS [Price]
	,1 AS [PriceType]
	,YEAR([Date]) * 100 + MONTH([Date]) AS [DateKey]
	,NULL
	,@GetDate
	,'system'
	,@GetDate
	,'system'
FROM [NLREPORTING-P].[JetStage_US].[dbo].[DataStatic_dbo_FactSalesForecast_US]
WHERE [Date] >= @StartDate
GROUP BY [Domestic_FOB], [ForecastingEntity], [Date], [Brand_Code], [Item No_]
GO
