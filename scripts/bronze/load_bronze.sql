
--===========================================================
--  Load data into the crm bronze layer
--===========================================================
CREATE
or ALTER PROCEDURE load_bronze AS BEGIN DECLARE @start_time DATETIME,
@end_time DATETIME,
@batch_start_time DATETIME,
@batch_end_time DATETIME;

BEGIN TRY PRINT '>>> truncate and load data into the bronze layer';

SET
    @batch_start_time = GETDATE();

PRINT '================================================';

SET
    @start_time = GETDATE();

TRUNCATE TABLE bronze.crm_cust_info;

bulk
insert
    bronze.crm_cust_info
from
    'D:\Datawarehouse\dataset\source_crm\cust_info.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

SET
    @end_time = GETDATE();

print '>>> load data into bronze.crm_cust_info, time taken: ' + cast(
    datediff(second, @start_time, @end_time) as varchar(10)
) + ' seconds';

SET
    @start_time = GETDATE();

truncate table bronze.crm_prd_info;

bulk
insert
    bronze.crm_prd_info
from
    'D:\Datawarehouse\dataset\source_crm\prd_info.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

SET
    @end_time = GETDATE();

SET
    @start_time = GETDATE();

truncate table bronze.crm_sales_details;

bulk
insert
    bronze.crm_sales_details
from
    'D:\Datawarehouse\dataset\source_crm\sales_details.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

SET
    @end_time = GETDATE();

--===========================================================
--  Load data into the crm bronze layer
--===========================================================
PRINT '>>> truncate and load data into the bronze layer';

truncate table bronze.erp_loc_a101;

bulk
insert
    bronze.erp_loc_a101
from
    'D:\Datawarehouse\dataset\source_erp\LOC_A101.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

truncate table bronze.erp_cust_az12;

bulk
insert
    bronze.erp_cust_az12
from
    'D:\Datawarehouse\dataset\source_erp\CUST_AZ12.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

TRUNCATE table bronze.erp_px_cat_g1v2;

bulk
insert
    bronze.erp_px_cat_g1v2
from
    'D:\Datawarehouse\dataset\source_erp\PX_CAT_G1V2.csv' with (
        firstrow = 2,
        fieldterminator = ',',
        tablock
    );

END TRY 
BEGIN CATCH 
 PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
  PRINT 'Error Message' + ERROR_MESSAGE();

PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);

PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);

PRINT '=========================================='
END CATCH
END
