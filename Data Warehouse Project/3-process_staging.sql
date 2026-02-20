/*==============================================================
Load procedure: load data from source to staging schema.
=================================================================
This stored procedure load data into the staging schema from extrenal files'CVS'.
-Truncate the staging tables before loading data.
-Use 'bulk insert' to load data from cvs file to staging schama.
this stored procedure dose not accept any parameters or return any value.
=====================================================================================

*/
CREATE OR ALTER PROCEDURE staging.load_staging AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY 
	SET @batch_start_time=GETDATE();
	PRINT'==================================================';
	PRINT'==========Loading staging layer===================';
	PRINT'==================================================';
	-----------------------------------------------------------
	SET @start_time=GETDATE();
	

	PRINT'***Truncating table: staging.Customrs ';
	TRUNCATE TABLE staging.Customers;
	PRINT'***Inserting table: staging.Customrs ';
	BULK INSERT staging.Customers
	FROM'C:\Users\ASUS\Downloads\E_commeric_data\Customers.csv'
	with(
	ROWTERMINATOR = '0x0a',
	 FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    TABLOCK
	);
	
	SET @end_time=GETDATE();
	PRINT'Load Duration'+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR )+'Seconds';
	PRINT'*************'
	-----================================================---------
	SET @start_time=GETDATE();
	PRINT'***Truncating table: staging.OrderItems ';
	TRUNCATE TABLE staging.OrderItems;
	PRINT'***Inserting table: staging.OrderItems ';
	BULK INSERT staging.OrderItems
	FROM'C:\Users\ASUS\Downloads\E_commeric_data\OrderItems.csv'
	with(
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT'Load Duration'+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+'Seconds';
	PRINT'*************'
	---=====================================================-----------
	SET @start_time=GETDATE();
	PRINT'***Truncating table: staging.Orders ';
	TRUNCATE TABLE staging.Orders;
	PRINT'***Inserting table: staging.Orders ';
	BULK INSERT staging.Orders
	FROM'C:\Users\ASUS\Downloads\E_commeric_data\Orders.csv'
	with(
	FIRSTROW=2,
	ROWTERMINATOR = '0x0a',

	FIELDTERMINATOR=',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT'Load Duration'+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+'Seconds';
	PRINT'*************';

	----------====================================================----------

	---=====================================================-----------
	SET @start_time=GETDATE();
	PRINT'***Truncating table: staging.Payments ';
	TRUNCATE TABLE staging.Payments;
	PRINT'***Inserting table: staging.Payments ';
	BULK INSERT staging.Payments
	FROM'C:\Users\ASUS\Downloads\E_commeric_data\Payments.csv'
	with(
	ROWTERMINATOR = '0x0a',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT'Load Duration'+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+'Seconds';
	PRINT'*************';
	-----=======================================================================-----
	SET @start_time=GETDATE();
	PRINT'***Truncating table: staging.Products ';
	TRUNCATE TABLE staging.Products;
	PRINT'***Inserting table: staging.Products ';
	BULK INSERT staging.Products
	FROM'C:\Users\ASUS\Downloads\E_commeric_data\Products.csv'
	with(
	FIRSTROW=2,
	ROWTERMINATOR = '0x0a',
	FIELDTERMINATOR=',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT'Load Duration'+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+'Seconds';
	PRINT'*************';
	------------------------------------------------------------
	SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Staging Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		END TRY
		BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH






END