# SQL Data Warehouse Project – Medallion Architecture (Bronze, Silver & Gold Layers)

Welcome to the SQL Data Warehouse Project repository.  
This project demonstrates the role of a Data Analyst in working with all three layers of the Medallion Architecture data warehouse pipeline:

- **Bronze Layer** – Ingest raw data from multiple sources (CRM and ERP CSV files) into SQL Server Management Studio (SSMS) with minimal transformation.  
- **Silver Layer** – Prepare curated, cleaned, and structured datasets.  
- **Gold Layer** – Create analytics-ready tables for reporting and business intelligence.  

This reflects a scenario where a Data Analyst may handle initial ingestion for basic staging (Bronze) and then focus heavily on validation, transformation, modeling, and analysis in Silver and Gold layers.

---

## 📂 Repository Structure
```
SQL-DATA-WAREHOUSE-PROJECT/
├── datasets/
│ ├── crm_sales_details.csv
│ ├── crm_cust_info.csv
│ ├── crm_prd_info.csv
│ ├── erp_cust_az12.csv
│ ├── erp_loc_a101.csv
│ └── erp_px_cat_g1v2.csv
│
├── Docs/
│ ├── data_catalog.md
│ ├── data_flow.md
│ ├── data_integration.md
│ └── data_model.md
│
├── scripts/
│ ├── bronze_load.sql
│ ├── silver_transform.sql
│ └── gold_analysis.sql
│
├── tests/
│ ├── quality_checks_silver.sql
│ └── quality_checks_gold.sql
│
├── LICENSE
└── README.md
```
---

## 📊 Project Diagrams
### Data Flow
<img width="965" height="658" alt="data_flow_gen" src="https://github.com/user-attachments/assets/c8177201-ab65-4eaf-b673-392ba9743707" />


### Data Integration
<img width="1522" height="747" alt="data_integration" src="https://github.com/user-attachments/assets/6f3bde98-9693-4dfa-8f99-b4bb50f9290c" />

### Data Mart(Star schema)
<img width="997" height="507" alt="data_model_gen" src="https://github.com/user-attachments/assets/be94f477-0c4d-4469-8cba-943347e7457b" />

---

## 📌 Project Requirements

### 1. Data Preparation & Modeling (Data Analyst Role)

**Objective**  
Ingest and transform data into structured models and insights to support decision-making.

**Responsibilities**
- **Bronze Layer** – Load raw CRM and ERP CSV files into staging tables with minimal cleaning.
- **Data Validation** – Review data for completeness, duplicates, and errors.
- **Silver Layer** – Organize curated datasets into a query-friendly format.
- **Gold Layer** – Build aggregated, analytics-ready tables for BI and reporting.
- **Data Analysis** – Write SQL queries to uncover trends, KPIs, and actionable insights.
- **Documentation** – Maintain table definitions and transformation logic.

---

### 2. BI: Analytics & Reporting

**Objective**  
Deliver insights from the Gold layer to support business strategies and performance monitoring.

**Insights Generated**
- Customer Behavior
- Product Performance
- Sales Trends

These findings enable stakeholders to make informed, data-driven decisions.

---

## 🏗 Medallion Architecture Benefits
- **Bronze Layer**: Preserves raw source data for traceability.  
- **Silver Layer**: Ensures high-quality, standardized datasets.  
- **Gold Layer**: Provides business-ready, aggregated data for analytics and dashboards.  

Following this layered architecture improves data quality, enables incremental processing, and supports scalable analytics workflows.

---

## 📜 License
This project is licensed under the MIT License. You are free to use, modify, and share it with proper attribution.

---

## 👩‍💻 About Me
Hi there! I’m Selsiya Ganesan, an aspiring Data Analyst with an MBA in Business Analytics & HR.  
I specialize in SQL, Excel, Power BI, and analytics workflows that turn data into meaningful insights for business.


