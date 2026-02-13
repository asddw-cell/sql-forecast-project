
/*

==============================================================================

Import ForecastCustomer for UK

==============================================================================

Script Purpose:
	This script inserts initial data to tblForecastCustomer_UK from a SELECT statement against the Forecasting Entity fact table
    in the UK staging database. All customers are defaulted to Active and this should be reviewed.
	

*/

USE [Forecast]
GO

INSERT INTO [dbo].[tblForecastCustomer_UK] (
	[Code]
	,[Description]
	,[Active]
	)
SELECT [Code]
	,[Name]
	,1
FROM [NLREPORTING-P].[JetStage2_UK].[dbo].[DataStatic_dbo_DimForecastingEntity_UK]
WHERE [Code] LIKE 'UK_%'
GO
