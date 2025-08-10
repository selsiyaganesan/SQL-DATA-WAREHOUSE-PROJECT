/*
=============================================================
SQL Data Warehouse – Medallion Architecture Setup
=============================================================
Script Purpose:
This script creates a new database named 'DataWarehouse' following the Medallion Architecture 
(Bronze, Silver, Gold layers). If the database already exists, it is dropped and recreated. 

Layers:
- Bronze: Stores raw, ingested data from source systems (CRM & ERP CSV files).
- Silver: Stores cleaned, curated datasets ready for analysis.
- Gold: Stores aggregated, analytics-ready data for BI and reporting.

WARNING:
Running this script will DROP the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. 
Proceed with caution and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas for Medallion Architecture
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO


