/*
============================================================================================
Stored Procedure: load_bronze (Source -> Bronze)
============================================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from CRM and ERP CSV files.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze;
============================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time=GETDATE();
		PRINT '===========================';
		PRINT 'loading bronze layer';
		PRINT '===========================';

		PRINT '---------------------------';
		PRINT 'loading crm tables';
		PRINT '---------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info;
		PRINT '>>insert into Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info 
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;
		PRINT '>>insert into Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info 
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;
		PRINT '>>insert into Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		PRINT '---------------------------';
		PRINT 'loading erp tables';
		PRINT '---------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.erp_CUST_AZ12';
		TRUNCATE TABLE Bronze.erp_CUST_AZ12;
		PRINT '>>insert into Bronze.erp_CUST_AZ12';
		BULK INSERT Bronze.erp_CUST_AZ12
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.erp_LOC_A101';
		TRUNCATE TABLE Bronze.erp_LOC_A101;
		PRINT '>>insert into Bronze.erp_LOC_A101';
		BULK INSERT Bronze.erp_LOC_A101
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2;
		PRINT '>>insert into Bronze.erp_PX_CAT_G1V2';
		BULK INSERT Bronze.erp_PX_CAT_G1V2
		FROM 'C:\ProgramData\Microsoft OneDrive\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';
	SET @batch_end_time=GETDATE();
	PRINT '======================================================';
	PRINT 'loading bronze layer is completed';
	PRINT '-Total load duration:'+CAST(DATEDIFF(Second,@batch_start_time,@batch_end_time) AS NVARCHAR)+'Seconds';
	PRINT '======================================================';
	END TRY
	BEGIN CATCH
	PRINT '==================================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT 'Error message'+ERROR_MESSAGE();
	PRINT 'Error message'+CAST(ERROR_NUMBER()AS NVARCHAR);
	PRINT 'Error message'+CAST(ERROR_STATE()AS NVARCHAR);
	PRINT '==================================================';
	END CATCH
END        
