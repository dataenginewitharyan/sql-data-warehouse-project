/*
====================================================================================
Stored Procedure: Load Silver Layer (Transformations)
====================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    BEGIN TRY
        -- Load crm_cust_info
        TRUNCATE TABLE silver.crm_cust_info;
        INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_first_name, cst_last_name, cst_marital_status, cst_gender, cst_create_date)
        SELECT cst_id, cst_key, TRIM(cst_first_name), TRIM(cst_last_name),
               CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
                    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' ELSE 'n/a' END,
               CASE WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female' 
                    WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male' ELSE 'n/a' END,
               cst_create_date
        FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag FROM bronze.crm_cust_info) t 
        WHERE flag = 1 AND cst_id IS NOT NULL;

        -- Load crm_prd_info
        TRUNCATE TABLE silver.crm_prd_info;
        INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
        SELECT prd_id, REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'), SUBSTRING(prd_key, 7, LEN(prd_key)),
               prd_nm, ISNULL(prd_cost, 0),
               CASE UPPER(TRIM(prd_line)) WHEN 'M' THEN 'Mountains' WHEN 'R' THEN 'Road' WHEN 'T' THEN 'Touring' WHEN 'S' THEN 'Other Sales' ELSE 'n/a' END,
               CAST(prd_start_dt AS DATE),
               CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
        FROM bronze.crm_prd_info;

        -- Load crm_sales_details
        TRUNCATE TABLE silver.crm_sales_details;
        INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
        SELECT sls_ord_num, sls_prd_key, sls_cust_id,
               TRY_CAST(CAST(NULLIF(sls_order_dt,0) AS VARCHAR(8)) AS DATE),
               TRY_CAST(CAST(NULLIF(sls_ship_dt,0) AS VARCHAR(8)) AS DATE),
               TRY_CAST(CAST(NULLIF(sls_due_dt,0) AS VARCHAR(8)) AS DATE),
               CASE WHEN sls_sales <= 0 OR sls_sales IS NULL THEN sls_quantity * ABS(sls_price) ELSE sls_sales END,
               sls_quantity, CAST(sls_price AS DECIMAL(18,2))
        FROM bronze.crm_sales_details;

        -- Load ERP Tables (Simplified Cleanse)
        TRUNCATE TABLE silver.erp_loc_a101;
        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT REPLACE(cid, '-', ''), CASE WHEN TRIM(cntry) = '' THEN 'n/a' ELSE TRIM(cntry) END FROM bronze.erp_loc_a101;

        TRUNCATE TABLE silver.erp_cust_az12;
        INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
        SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, 50) ELSE cid END,
               CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END,
               CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female' WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male' ELSE 'n/a' END
        FROM bronze.erp_cust_az12;

        TRUNCATE TABLE silver.erp_px_cat_g1v2;
        INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
        SELECT id, cat, subcat, maintenance FROM bronze.erp_px_cat_g1v2;

        PRINT '>> Silver Layer Loaded successfully';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
