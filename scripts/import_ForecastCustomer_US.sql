/*

==============================================================================

Import ForecastCustomer for US

==============================================================================

Script Purpose:
	This script inserts initial data to tblForecastCustomer_US from a SELECT statement against the Forecasting Entity fact table
    in the US staging database. All customers are set as Active and this should be reviewed.
	

*/

USE [Forecast]
GO

INSERT INTO [dbo].[tblForecastCustomer_US] (
	[Code]
	,[Description]
	,[Active]
	)
SELECT [Code]
	,[Name]
	,1
FROM [NLREPORTING-P].[JetStage_US].[dbo].[DataStatic_dbo_DimForecastingEntity_US]
WHERE [Code] LIKE 'US_%'
GO
