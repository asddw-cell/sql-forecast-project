
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

DECLARE @StartDate AS DATE;

SET @StartDate = '2026-04-01'

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
	,NULL
	,NULL
	,NULL
	,NULL
FROM [NLREPORTING-P].[JetStage_US].[dbo].[DataStatic_dbo_FactSalesForecast_US]
WHERE [Date] >= @StartDate
GROUP BY [Domestic_FOB], [ForecastingEntity], [Date], [Brand_Code], [Item No_]
GO
