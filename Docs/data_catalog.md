## Data Dictionary for Gold Layer

### Overview  
The **Gold Layer** is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** designed for specific business metrics.

---

### 1. `gold.dim_customer`  

**Purpose**: Stores enriched customer details with demographic and geographic information.  

| Column Name     | Data Type     | Description |
|-----------------|--------------|-------------|
| customer_key    | INT          | Surrogate key generated using `ROW_NUMBER()` to uniquely identify each customer record in the dimension table. |
| customer_id     | INT          | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| firstname       | NVARCHAR(50) | Customer's first name as recorded in the system. |
| lastname        | NVARCHAR(50) | Customer's last name or family name. |
| country         | NVARCHAR(50) | Country of residence for the customer (e.g., "Australia"). |
| marital_status  | NVARCHAR(20) | Marital status of the customer (e.g., "Married", "Single"). |
| gender          | NVARCHAR(10) | Gender of the customer. Uses ERP gender data when available, defaults to 'n/a'. |
| birthdate       | DATE         | Customer's date of birth. |
| create_date     | DATE         | Date the customer record was created in the system. |

---

### 2. `gold.dim_product`  

**Purpose**: Stores detailed product information with category and cost details for analytics.  

| Column Name     | Data Type     | Description |
|-----------------|--------------|-------------|
| product_key     | INT          | Surrogate key generated using `ROW_NUMBER()` to uniquely identify each product record in the dimension table. |
| product_id      | INT          | Unique numerical identifier assigned to each product. |
| product_number  | NVARCHAR(50) | Alphanumeric identifier representing the product, used for tracking and referencing. |
| product_name    | NVARCHAR(100)| Name of the product. |
| category_id     | INT          | Numerical identifier for the product category. |
| category        | NVARCHAR(50) | Category name (e.g., "Electronics"). |
| sub_category    | NVARCHAR(50) | Sub-category name under the main category. |
| maintenance     | NVARCHAR(50) | Maintenance status or type associated with the product. |
| cost            | FLOAT        | Cost price of the product. |
| product_line    | NVARCHAR(50) | Product line or series to which the product belongs. |
| start_date      | DATE         | Date the product became active. |

---

### 3. `gold.fact_sales`  

**Purpose**: Stores sales transaction details for analysis of revenue, quantity, and order timelines.  

| Column Name   | Data Type     | Description |
|---------------|--------------|-------------|
| order_number  | NVARCHAR(50) | Unique sales order number. |
| product_key   | INT          | Foreign key linking to `gold.dim_product` for product details. |
| customer_key  | INT          | Foreign key linking to `gold.dim_customer` for customer details. |
| order_date    | DATE         | Date when the order was placed. |
| ship_date     | DATE         | Date when the order was shipped. |
| due_date      | DATE         | Date when the order was due for delivery. |
| sales_amount  | FLOAT        | Total sales value for the order line. |
| quantity      | INT          | Number of units sold. |
| price         | FLOAT        | Price per unit for the product in the order. |
