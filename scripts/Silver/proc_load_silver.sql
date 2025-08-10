/*
============================================================================================
Stored Procedure: load_silver (Bronze -> Silver)
============================================================================================
Script Purpose:
  This stored procedure transforms and cleans data from the 'bronze' schema
  and loads it into the 'silver' schema.
  It performs the following actions:
    - Extracts curated datasets from Bronze tables.
    - Applies data cleaning, validation, and transformation rules.
    - Loads the processed data into Silver tables for further analysis.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC silver.load_silver;
============================================================================================
*/
CREATE OR ALTER PROCEDURE Silver.load_silver AS 
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time=GETDATE();
		PRINT '===========================';
		PRINT 'loading Silver layer';
		PRINT '===========================';

		PRINT '---------------------------';
		PRINT 'loading crm tables';
		PRINT '---------------------------';
		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.crm_cust_info';
		TRUNCATE TABLE [Silver].[crm_cust_info];
		PRINT '>>insert data into:Silver.crm_cust_info';
		INSERT INTO [Silver].[crm_cust_info]
		(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
			 WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
			 ELSE 'n/a'
		END cst_marital_status,
		CASE WHEN cst_gndr='M' THEN 'Male'
			 WHEN cst_gndr='F' THEN 'Female'
			 ELSE 'n/a'
		END cst_gndr,
		cst_create_date
		FROM
		(
		SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS cst_unique
		FROM [Bronze].[crm_cust_info]
		WHERE cst_id IS NOT NULL
		)t WHERE cst_unique=1
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.crm_prd_info';
		TRUNCATE TABLE [Silver].[crm_prd_info];
		PRINT '>>insert data into:Silver.crm_prd_info';
		INSERT INTO [Silver].[crm_prd_info]
		(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
		SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost,0) AS prd_cost,
		CASE prd_line
			WHEN 'M' THEN 'Mountain'
			WHEN 'T' THEN 'Touring'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'R' THEN 'Road'
			ELSE 'n/a'
		END prd_line,
		CAST(prd_start_dt AS DATE) prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS date) AS prd_end_dt
		FROM [Bronze].[crm_prd_info]
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.crm_sales_details';
		TRUNCATE TABLE [Silver].[crm_sales_details];
		PRINT '>>insert data into:Silver.crm_sales_details';
		INSERT INTO [Silver].[crm_sales_details]
		(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!=8 THEN NULL
			 ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
		END sls_order_dt,
		CAST(CAST(sls_ship_dt as VARCHAR) AS date) AS sls_ship_dt,
		CAST(CAST(sls_due_dt AS VARCHAR) AS date) AS sls_due_dt,
		CASE WHEN sls_sales<=0 OR sls_sales!=sls_quantity* ABS(sls_price) OR sls_sales IS NULL
		THEN sls_quantity* ABS(sls_price)
			 ELSE sls_sales
		END sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price<=0 THEN sls_sales/NULLIF(sls_quantity,0)
			 ELSE ABS(sls_price)
		END sls_price
		FROM [Bronze].[crm_sales_details]
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		PRINT '---------------------------';
		PRINT 'loading erp tables';
		PRINT '---------------------------';
		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.erp_CUST_AZ12';
		TRUNCATE TABLE Silver.erp_CUST_AZ12;
		PRINT '>>insert data into:Silver.erp_CUST_AZ12';
		INSERT INTO Silver.erp_CUST_AZ12
		(
			CID,
			BDATE,
			GEN
		)
		SELECT  
		CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
			 ELSE CID
		END CID,
		CASE WHEN BDATE>GETDATE() THEN NULL
			 ELSE BDATE
		END BDATE,
		CASE WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'Male'
			 WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
			 ELSE 'n/a'
		END GEN
		FROM [Bronze].[erp_CUST_AZ12]
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.erp_LOC_A101';
		TRUNCATE TABLE Silver.erp_LOC_A101;
		PRINT '>>insert data into:Silver.erp_LOC_A101';
		INSERT INTO Silver.erp_LOC_A101
		(
			CID,
			CNTRY
		)
		SELECT 
		REPLACE(CID,'-','') AS CID,
		CASE WHEN CNTRY='DE' THEN 'Germany'
			 WHEN CNTRY IN ('US','USA') THEN 'United States'
			 WHEN CNTRY=' ' OR CNTRY IS NULL THEN 'n/a'
			 ELSE CNTRY
		END CNTRY
		FROM [Bronze].[erp_LOC_A101]
		SET @end_time=GETDATE();
		PRINT '>>load duration:'+CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		PRINT '----------------------------';

		SET @start_time=GETDATE();
		PRINT '>>truncate table:Silver.erp_PX_CAT_G1V2';
		TRUNCATE TABLE [Silver].[erp_PX_CAT_G1V2];
		PRINT '>>insert data into:Silver.erp_PX_CAT_G1V2';
		INSERT INTO [Silver].[erp_PX_CAT_G1V2]
		(
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		SELECT
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		FROM [Bronze].[erp_PX_CAT_G1V2]
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
