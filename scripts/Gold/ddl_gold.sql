/*
============================================================================================
DDL Script: Create Gold Views
============================================================================================

Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final presentation layer, typically organized 
    in a Star Schema for analytics and reporting.

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics, dashboards, and BI tools.

============================================================================================
*/

--===================================================
--Create dimension table:gold.dim_customer
--===================================================
IF OBJECT_ID ('gold.dim_customer','U') IS NOT NULL
	DROP VIEW gold.dim_customer
GO
CREATE VIEW gold.dim_customer AS
SELECT
ROW_NUMBER() OVER (ORDER BY cs.cst_id) AS customer_key, --master id
cs.cst_id AS customer_id,
cs.cst_key AS customer_number,
cs.cst_firstname AS firstname,
cs.cst_lastname AS lastname,
ec.CNTRY AS country,
cs.cst_marital_status AS marital_status,
CASE WHEN cs.cst_gndr!='n/a' THEN cs.cst_gndr
	 ELSE COALESCE(es.GEN,'n/a')
END gender,
es.BDATE AS birthdate,
cs.cst_create_date AS create_date
FROM [Silver].[crm_cust_info] AS cs
LEFT JOIN [Silver].[erp_CUST_AZ12] AS es
ON cs.cst_key=es.CID
LEFT JOIN [Silver].[erp_LOC_A101] AS ec
ON cs.cst_key=ec.CID
GO
--===================================================
--Create dimension table:gold.dim_product
--===================================================
IF OBJECT_ID ('gold.dim_product','U') IS NOT NULL
	DROP VIEW gold.dim_product
GO
CREATE VIEW gold.dim_product AS
SELECT
ROW_NUMBER() OVER (ORDER BY sp.prd_key) AS product_key,
sp.prd_id AS product_id,
sp.prd_key AS product_number,
sp.prd_nm AS product_name,
sp.cat_id AS category_id,
Se.CAT AS category,
Se.SUBCAT AS sub_category,
Se.MAINTENANCE AS maintenance,
sp.prd_cost AS cost,
sp.prd_line AS product_line,
sp.prd_start_dt AS start_date
FROM [Silver].[crm_prd_info] AS sp
LEFT JOIN [Silver].[erp_PX_CAT_G1V2] AS Se
ON sp.cat_id=Se.ID
WHERE prd_end_dt IS NULL --filter out all historical data
GO
--===================================================
--Create dimension table:gold.fact_sales
--===================================================
IF OBJECT_ID ('gold.fact_sales','U') IS NOT NULL
	DROP VIEW gold.fact_sales
GO
CREATE VIEW Gold.fact_sales AS
SELECT
sc.sls_ord_num AS order_number,
gp.product_key,
gc.customer_key,
sc.sls_order_dt AS order_date,
sc.sls_ship_dt AS ship_date,
sc.sls_due_dt AS due_date,
sc.sls_sales AS sales_amount,
sc.sls_quantity AS quantity,
sc.sls_price AS price
FROM [Silver].[crm_sales_details] AS sc
LEFT JOIN Gold.dim_product AS gp
ON sc.sls_prd_key=gp.product_number
LEFT JOIN Gold.dim_customer AS gc
ON sc.sls_cust_id=gc.customer_id
GO
