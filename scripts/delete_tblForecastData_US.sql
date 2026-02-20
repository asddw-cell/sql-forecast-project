ALTER TABLE [dbo].[tblForecastData_US]
SET (SYSTEM_VERSIONING = OFF);

DELETE FROM [dbo].[tblForecastData_US];
DELETE FROM [dbo].[tblForecastData_USHistory];

DBCC CHECKIDENT ('dbo.tblForecastData_US', RESEED, 0);

ALTER TABLE [dbo].[tblForecastData_US]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[tblForecastData_USHistory]));
