/*

========================================================

Create Database

========================================================

Script Purpose:
	This script creates a new database called 'Forecast' after checking if it already exists.
	If the database exists, it is dropped and recreated.

Warning:
	Running this script will drop the entire 'Forecast' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution
	and ensure you have proper backups before running this script.
*/

USE [master]
GO

/****** Object:  Database [Forecast]    Script Date: 06/02/2026 14:37:04 ******/

-- Drop and recreate the 'Forecast' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Forecast')
BEGIN
	ALTER DATABASE Forecast SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Forecast;
END;
GO

-- Create the 'Forecast' database
CREATE DATABASE [Forecast];
GO
