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

**Purpose**: Provides information about the products and their attributes.

| Column Name           | Data Type     | Description |
|-----------------------|--------------|-------------|
| product_key           | INT          | Surrogate key uniquely identifying each product record in the product dimension table. |
| product_id            | INT          | A unique identifier assigned to the product for internal tracking and referencing. |
| product_number        | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name          | NVARCHAR(50) | Descriptive name of the product, including key details such as type, color, and size. |
| category_id           | NVARCHAR(50) | A unique identifier for the product’s category, linking to its high-level classification. |
| category              | NVARCHAR(50) | The broader classification of the product (e.g., Bikes, Components) to group related items. |
| subcategory           | NVARCHAR(50) | A more detailed classification of the product within the category, such as product type. |
| maintenance           | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., "Yes", "No"). |
| cost                  | INT          | The cost or base price of the product, measured in monetary units. |
| product_line          | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g., Road, Mountain). |
| start_date            | DATE         | The date when the product became available for sale or use. |

---

### 3. `gold.fact_sales`

**Purpose**: Contains transactional sales data, linking products and customers, along with order and shipment details.

| Column Name   | Data Type     | Description |
|---------------|--------------|-------------|
| order_number  | NVARCHAR(50) | The unique identifier for each sales order. |
| product_key   | INT          | Foreign key linking to `gold.dim_product` to retrieve product details. |
| customer_key  | INT          | Foreign key linking to `gold.dim_customer` to retrieve customer details. |
| order_date    | DATE         | The date when the sales order was placed. |
| ship_date     | DATE         | The date when the product was shipped to the customer. |
| due_date      | DATE         | The expected delivery date for the sales order. |
| sales_amount  | INT          | The total sales value for the specific line item in the sales order. |
| quantity      | INT          | The number of units sold in the transaction. |
| price         | INT          | The selling price per unit of the product. |


