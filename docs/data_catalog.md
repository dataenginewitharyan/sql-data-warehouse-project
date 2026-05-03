# Data Catalog for Gold Layer

## Overview
The Gold Layer represents the final, business-ready data representation, structured in a Star Schema to support analytical and reporting use cases[cite: 1]. It consists of dimension tables for descriptive attributes and fact tables for quantitative business metrics[cite: 1].

---

### 1. gold.dim_customers
- **Purpose:** Stores the "Golden Record" of customer details, enriched with demographic and geographic data[cite: 1]. It prioritizes CRM data and uses ERP data as a fallback[cite: 1].
- **Columns:**

| Column Name      | Data Type     | Description |
|------------------|---------------|-------------|
| **customer_key** | INT           | Surrogate key uniquely identifying each customer record, generated via `ROW_NUMBER()`[cite: 1]. |
| **customer_id**   | INT           | Unique numerical identifier assigned to each customer in the source system[cite: 1]. |
| **customer_number**| NVARCHAR(50)  | Alphanumeric identifier used for tracking and referencing (mapped from `cst_key`)[cite: 1]. |
| **first_name**    | NVARCHAR(50)  | The customer's first name (mapped from `cst_firstname`)[cite: 1]. |
| **last_name**     | NVARCHAR(50)  | The customer's last name or family name (mapped from `cst_lastname`)[cite: 1]. |
| **country**       | NVARCHAR(50)  | The country of residence for the customer (mapped from `la.cntry`)[cite: 1]. |
| **marital_status**| NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single')[cite: 1]. |
| **gender**        | NVARCHAR(50)  | The standardized gender of the customer, using CRM as the master source[cite: 1]. |
| **birth_date**    | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD[cite: 1]. |
| **create_date**   | DATE          | The date when the customer record was created in the system[cite: 1]. |

---

### 2. gold.dim_products
- **Purpose:** Provides a unified view of products and their hierarchical attributes[cite: 1].
- **Columns:**

| Column Name      | Data Type     | Description |
|------------------|---------------|-------------|
| **product_key**   | INT           | Surrogate key uniquely identifying each product record, ordered by start date and ID[cite: 1]. |
| **product_id**    | INT           | A unique identifier assigned to the product for internal tracking[cite: 1]. |
| **product_number**| NVARCHAR(50)  | A structured alphanumeric code representing the product (mapped from `prd_key`)[cite: 1]. |
| **product_name**  | NVARCHAR(50)  | Descriptive name of the product (mapped from `prd_nm`)[cite: 1]. |
| **category_id**   | NVARCHAR(50)  | A unique identifier for the product's high-level classification[cite: 1]. |
| **category**      | NVARCHAR(50)  | The broader classification of the product (e.g., 'Bikes', 'Components')[cite: 1]. |
| **subcategory**   | NVARCHAR(50)  | A more detailed classification within the category[cite: 1]. |
| **maintenance**   | NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No')[cite: 1]. |
| **cost**          | INT           | The base cost of the product, measured in monetary units[cite: 1]. |
| **product_line**  | NVARCHAR(50)  | The specific product series (e.g., 'Road', 'Mountain')[cite: 1]. |
| **start_date**    | DATE          | The date when the product became available for sale or use[cite: 1]. |

---

### 3. gold.fact_sales
- **Purpose:** Stores transactional sales data for analytical purposes, linked to the dimensions above[cite: 1].
- **Columns:**

| Column Name     | Data Type     | Description |
|-----------------|---------------|-------------|
| **order_number**| NVARCHAR(50)  | A unique identifier for each sales order (mapped from `sls_ord_num`)[cite: 1]. |
| **product_key** | INT           | Surrogate key linking the order to the `gold.dim_products` table[cite: 1]. |
| **customer_key**| INT           | Surrogate key linking the order to the `gold.dim_customers` table[cite: 1]. |
| **order_date**  | DATE          | The date when the order was placed[cite: 1]. |
| **shipping_date**| DATE          | The date when the order was shipped to the customer[cite: 1]. |
| **due_date**    | DATE          | The date when the order payment was due[cite: 1]. |
| **sales_amount**| INT           | The total monetary value of the sale (mapped from `sls_sales`)[cite: 1]. |
| **quantity**    | INT           | The number of units ordered (mapped from `sls_quantity`)[cite: 1]. |
| **price**       | INT           | The price per unit for the line item (mapped from `sls_price`)[cite: 1]. |
