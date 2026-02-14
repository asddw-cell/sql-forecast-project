

/*

==============================================================================

Import ForecastData for US

==============================================================================

Script Purpose:
	This script inserts initial data to tblForecastData_US from a SELECT statement against the Sales Forecast fact table
    in the US staging database. The @StartDate and @ForecastCustomer variables are used to filter the data.
	

*/
USE [Forecast]
GO

DECLARE 
	@StartDate AS date = '2026-01-01',
	@GetDate AS datetime = GETDATE(),
	@OpenDate date = DATEADD(MONTH, 3, GETDATE()),
	@ForecastCustomer AS nvarchar(20) = 'US_CA_WAL';

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
	,YEAR(@OpenDate) * 100 +MONTH(@OpenDate)
	,@GetDate
	,'system'
	,@GetDate
	,'system'
FROM [NLREPORTING-P].[JetStage_US].[dbo].[DataStatic_dbo_FactSalesForecast_US]
WHERE [Date] >= @StartDate
		AND [ForecastingEntity] = @ForecastCustomer
GROUP BY [Domestic_FOB], [ForecastingEntity], [Date], [Brand_Code], [Item No_]
GO
