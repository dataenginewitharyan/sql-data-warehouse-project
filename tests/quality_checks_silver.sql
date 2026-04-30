/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
Purpose: Verify that data cleansing and standardization rules were applied 
         correctly during the Silver load.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- 1. Check for Duplicate IDs (The Silver load uses ROW_NUMBER to remove these)
-- Expectation: No Results
SELECT cst_id, COUNT(*) FROM silver.crm_cust_info
GROUP BY cst_id HAVING COUNT(*) > 1;

-- 2. Verify Standardization of Gender/Marital Status
-- Expectation: Only 'Male', 'Female', 'Married', 'Single', or 'n/a'
SELECT DISTINCT cst_gender, cst_marital_status FROM silver.crm_cust_info;

-- 3. Check for Untrimmed Names
-- Expectation: No Results
SELECT cst_first_name, cst_last_name FROM silver.crm_cust_info
WHERE cst_first_name != TRIM(cst_first_name) OR cst_last_name != TRIM(cst_last_name);

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- 1. Verify Product Key Splitting (cat_id should be 5 chars, prd_key the rest)
-- Expectation: cat_id like 'XXXXX', prd_key without prefix
SELECT TOP 5 cat_id, prd_key FROM silver.crm_prd_info;

-- 2. Verify Product Line Standardization
-- Expectation: 'Mountains', 'Road', 'Touring', 'Other Sales', or 'n/a'
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- 3. Check Date Validity (Start Date should be <= End Date)
-- Expectation: No Results
SELECT * FROM silver.crm_prd_info WHERE prd_start_dt > prd_end_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- 1. Verify Date Conversion (Bronze INT -> Silver DATE)
-- Expectation: All values should be valid DATE types or NULL
SELECT TOP 5 sls_order_dt, sls_ship_dt, sls_due_dt FROM silver.crm_sales_details;

-- 2. Check Logical Date Flow
-- Expectation: No Results (Ship/Due should not be before Order)
SELECT * FROM silver.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- 3. Verify Sales Calculation (Sales = Quantity * Price)
-- Expectation: No Results (Allowing for small rounding differences if any)
SELECT sls_sales, sls_quantity, sls_price 
FROM silver.crm_sales_details
WHERE ABS(sls_sales - (sls_quantity * sls_price)) > 0.01;

-- ====================================================================
-- Checking ERP Tables
-- ====================================================================

-- 1. Check Location CID Formatting (Hyphens removed)
-- Expectation: No Results with '-'
SELECT cid FROM silver.erp_loc_a101 WHERE cid LIKE '%-%';

-- 2. Verify Country Standardization
-- Expectation: 'United States', 'Germany', etc. (No 'US' or 'USA')
SELECT DISTINCT cntry FROM silver.erp_loc_a101;

-- 3. Verify Customer Birthdates
-- Expectation: No future dates
SELECT * FROM silver.erp_cust_az12 WHERE bdate > GETDATE();

-- 4. Verify Customer Gender
-- Expectation: 'Male', 'Female', or 'n/a'
SELECT DISTINCT gen FROM silver.erp_cust_az12;
