-- =============================================================================
-- Stored Procedure: Load Bronze Layer
-- =============================================================================
--Script Purpose: This stored procedure loads data into the 'bronze' schemas from external CSV file.
--                It performs following actions:
--                    1)Truncate the bronze table before loading the data
--                    2)Uses the 'BULK'INSERT' command to load data from csv files tp bronze tables.

-- Usage Example:
--               EXEC bronze.load_bronze
-- =============================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time       DATETIME, 
            @end_time         DATETIME, 
            @batch_start_time DATETIME, 
            @batch_end_time   DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '===========================================================================';
        PRINT 'Loading Bronze layer';
        PRINT '===========================================================================';

        PRINT '---------------------------------------------------------------------------';
        PRINT 'Loading CRM tables...';
        PRINT '---------------------------------------------------------------------------';

        -- Load crm_cust_info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        -- Load crm_prd_info
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        -- Load crm_sales_details
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        PRINT '---------------------------------------------------------------------------';
        PRINT 'Loading ERP tables...';
        PRINT '---------------------------------------------------------------------------';

        -- Load erp_loc_a101
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/datasets/source_erp/loc_a101.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        -- Load erp_cust_az12
        SET @start_time = GETDATE();  
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/datasets/source_erp/cust_az12.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        -- Load erp_px_cat_g1v2
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/datasets/source_erp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR   = '0x0a',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Time taken to load erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '---------------------------------';

        SET @batch_end_time = GETDATE();

        PRINT '===========================================================================';
        PRINT 'Bronze layer loaded successfully';
        PRINT 'Batch time taken: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50)) + ' seconds';
        PRINT '===========================================================================';

    END TRY
    BEGIN CATCH
        PRINT '===========================================================================';
        PRINT 'ERROR OCCURRED WHILE LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT '===========================================================================';
    END CATCH
END;
GO

-- Execute the procedure
EXEC bronze.load_bronze;
