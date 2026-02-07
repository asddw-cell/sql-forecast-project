/*

==============================================================================

Insert brand data to tblBrand

==============================================================================

Script Purpose:
	This script creates a stored procedure called proc_Insert_tblBrand. The procedure deletes all rows in tblBrand and inserts
	all codes and descriptions from the Brands table in the DataWarehouse.

*/

USE [Forecast]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_Insert_tblBrand]
AS

BEGIN TRAN;

	SET NOCOUNT ON;

    DELETE FROM [dbo].[tblBrand];

	INSERT INTO [dbo].[tblBrand]
           ([Code]
           ,[Description])
     SELECT [Brand Code (BC)]
		  ,[Brand Name (BC)]
	FROM [JetDwh_Master].[dbo].[Brands]

COMMIT;
