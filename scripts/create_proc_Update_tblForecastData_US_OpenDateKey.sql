/*

==============================================================================

Update OpenDateKey field in tbl_ForecastData_US

==============================================================================

Script Purpose:
	This script creates a stored procedure called proc_Update_tblForecastData_US_OpenDateKey. The procedure updates the OpenDateKey field for
	all rows with a value in the format yyyymm. The number in the DATEADD function defines the number of months in the future that the data can be
	edited.
	
	This procedure should be scheduled to run on the 1st day of each month to advance the OpenDateKey.

*/

USE [Forecast]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_Update_tblForecastData_US_OpenDateKey]
AS

DECLARE @OpenDate date = DATEADD(MONTH, 3, GETDATE());

UPDATE [dbo].[tblForecastData_US]
SET [OpenDateKey] = YEAR(@OpenDate) * 100 +MONTH(@OpenDate);
