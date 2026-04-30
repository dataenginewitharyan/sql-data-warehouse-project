/*
====================================================================================
Stored Procedure: Load Bronze Layer
====================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME = GETDATE();
    
    BEGIN TRY
        PRINT '>> Starting Bulk Load...';

        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101 FROM '/var/opt/mssql/datasets/source_erp/loc_a101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12 FROM '/var/opt/mssql/datasets/source_erp/cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2 FROM '/var/opt/mssql/datasets/source_erp/px_cat_g1v2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);

        PRINT '>> Bronze Load Complete in ' + CAST(DATEDIFF(SECOND, @start_time, GETDATE()) AS NVARCHAR) + 's';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
