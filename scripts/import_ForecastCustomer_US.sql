/*

==============================================================================

Import ForecastCustomer for US

==============================================================================

Script Purpose:
	This script inserts initial data to tblForecastCustomer_US from a SELECT statement against the Forecasting Entity fact table
    in the US staging database. All customers are defaulted to Active and this should be reviewed. Amazon and Walmart names are
	transformed to create unique name values.
	

*/

USE [Forecast]
GO

INSERT INTO [dbo].[tblForecastCustomer_US] (
	[Code]
	,[Description]
	,[Active]
	)
SELECT [Code]
	,CASE
		WHEN [Code] = 'US_CA_AMA'
			THEN 'Amazon CA'
		WHEN [Code] = 'US_CA_WAL'
			THEN 'Walmart CA'
		WHEN [Code] = 'US_US_AMA'
			THEN 'Amazon US'
		WHEN [Code] = 'US_US_WAL'
			THEN 'Walmart US'
		ELSE [Name]
	END
	,1
FROM [NLREPORTING-P].[JetStage_US].[dbo].[DataStatic_dbo_DimForecastingEntity_US]
WHERE [Code] LIKE 'US_%'
GO
